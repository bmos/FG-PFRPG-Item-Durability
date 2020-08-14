-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

function onInit()
	if User.isHost() then
		DB.addHandler(DB.getPath('charsheet.*.inventorylist.*.broken'), 'onUpdate', onBrokenChanged)
	end
	registerOptions()
end

function registerOptions()
	OptionsManager.registerOption2('DESTROY_ITEM', false, 'option_header_game', 'opt_lab_item_destroyed', 'option_entry_cycler', 
		{ labels = 'enc_opt_item_destroyed_gone', values = 'gone', baselabel = 'enc_opt_item_destroyed_unequipped', baseval = 'unequipped', default = 'unequipped' })
end

---	This function checks if the damaged weapon's name matches any in the actions tab and, if so, adds their nodes to tDamagedWeapons.
--	@param nodeItem A databasenode pointing to the damaged item.
--	@return tDamagedWeapons A table of databasenodes pointing to the damaged item on the actions tab.
local function handleWeaponNodeArgs(nodeItem)
	local nodeChar = nodeItem.getChild('...')
	local sItemName = DB.getValue(nodeItem, 'name', '')
	
	local tDamagedWeapons = {}
	for _,nodeWeapon in pairs(DB.getChildren(nodeChar, 'weaponlist')) do
		if sItemName == DB.getValue(nodeWeapon, 'name', '') then
			table.insert(tDamagedWeapons, nodeWeapon)
		end
	end
	
	return tDamagedWeapons
end

function brokenWeapon(nodeItem, bIsBroken)
	local tDamagedWeapons = handleWeaponNodeArgs(nodeItem)

	if bIsBroken then
		for _,vNode in pairs(tDamagedWeapons) do
			DB.setValue(vNode, 'bonus', 'number', DB.getValue(vNode, 'bonusbak', 0) - 2)
			DB.setValue(vNode, 'critatkrange', 'number', 20)
			
			for _,vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
				DB.setValue(vvNode, 'bonus', 'number', DB.getValue(vvNode, 'bonusbak', 0) - 2)
				if DB.getValue(vvNode, 'critmult', 2) > 2 then
					DB.setValue(vvNode, 'critmult', 'number', 2)
				end
			end
		end
	else
		for _,vNode in pairs(tDamagedWeapons) do
			DB.setValue(vNode, 'bonus', 'number', DB.getValue(vNode, 'bonusbak', 0))
			DB.setValue(vNode, 'critatkrange', 'number', DB.getValue(vNode, 'critatkrangebak', 20))
			
			for _,vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
				DB.setValue(vvNode, 'bonus', 'number', DB.getValue(vvNode, 'bonusbak', 0))
				if DB.getValue(vvNode, 'critmultbak', 2) > 2 then
					DB.setValue(vvNode, 'critmult', 'number', DB.getValue(vvNode, 'critmultbak', 2))
				end
			end
		end
	end
end

local function brokenArmor(nodeItem, bIsBroken)
	if bIsBroken then
		DB.setValue(nodeItem, 'ac', 'number', math.floor(DB.getValue(nodeItem, 'acbak', 0) / 2))
		DB.setValue(nodeItem, 'bonus', 'number', math.floor(DB.getValue(nodeItem, 'bonusbak', 0) / 2))
		DB.setValue(nodeItem, 'checkpenalty', 'number', DB.getValue(nodeItem, 'checkpenaltybak', 0) * 2)
	else
		DB.setValue(nodeItem, 'ac', 'number', DB.getValue(nodeItem, 'acbak', 0))
		DB.setValue(nodeItem, 'bonus', 'number', DB.getValue(nodeItem, 'bonusbak', 0))
		DB.setValue(nodeItem, 'checkpenalty', 'number', DB.getValue(nodeItem, 'checkpenaltybak', 0))
	end
end

local function processItemCost(sItemCostBak)
	if string.match(sItemCostBak, '%-') or string.match(sItemCostBak, '%/') then return 0 end
	
	local sTrimmedItemCost = sItemCostBak:gsub('[^0-9.-]', '')
	if sTrimmedItemCost then
		nTrimmedItemCost = tonumber(sTrimmedItemCost)
		for k,v in pairs(TEGlobals.tDenominations) do
			if string.match(sItemCostBak, k) then
				return nTrimmedItemCost * v
			end
		end
	end

	return 0
end

local function brokenItemCost(nodeItem, bIsBroken)
	local sItemCostBak = DB.getValue(nodeItem, 'costbak', '')
	sItemCostBak = sItemCostBak:gsub(',+', '')
	sItemCostBak = sItemCostBak:gsub('%s+', '')

	local sItemCostSeperatorChar = string.match(sItemCostBak, '[%D]')
	local nItemCostSeperator = string.find(sItemCostBak, sItemCostSeperatorChar)

	local nItemCostNew = tonumber(string.sub(sItemCostBak, 1, nItemCostSeperator - 1))
	local sItemCostUnit = string.sub(sItemCostBak, nItemCostSeperator)

	if bIsBroken then
		DB.setValue(nodeItem, 'cost', 'string', (nItemCostNew * .75) .. ' ' .. sItemCostUnit)
	else
		DB.setValue(nodeItem, 'cost', 'string', sItemCostBak)
	end
end

local function brokenPenalties(nodeItem, bIsBroken)
	brokenItemCost(nodeItem, bIsBroken)
	local sItemType = string.lower(DB.getValue(nodeItem, 'type', ''))
	if sItemType:match('weapon') then brokenWeapon(nodeItem, bIsBroken) end
	if sItemType:match('armor') then brokenArmor(nodeItem, bIsBroken) end
	local sItemSubtype = string.lower(DB.getValue(nodeItem, 'subtype', ''))
end

local function removeBackup(nodeItem)
	if DB.getValue(nodeItem, 'costbak') then nodeItem.getChild('costbak').delete() end
	if DB.getValue(nodeItem, 'bonusbak') then nodeItem.getChild('bonusbak').delete() end
	if DB.getValue(nodeItem, 'acbak') then nodeItem.getChild('acbak').delete() end
	if DB.getValue(nodeItem, 'checkpenaltybak') then nodeItem.getChild('checkpenaltybak').delete() end
	
	local tDamagedWeapons = handleWeaponNodeArgs(nodeItem)
	for _,vNode in pairs(tDamagedWeapons) do
		if DB.getValue(vNode, 'bonusbak') then vNode.getChild('bonusbak').delete() end
		if DB.getValue(vNode, 'critatkrangebak') then vNode.getChild('critatkrangebak').delete() end
		for _,vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
			if DB.getValue(vvNode, 'bonusbak') then vvNode.getChild('bonusbak').delete() end
			if DB.getValue(vvNode, 'critmultbak') then vvNode.getChild('critmultbak').delete() end
		end
	end
end

local function makeBackup(nodeItem)
	DB.setValue(nodeItem, 'costbak', 'string', DB.getValue(nodeItem, 'cost', ''))
	DB.setValue(nodeItem, 'bonusbak', 'number', DB.getValue(nodeItem, 'bonus', 0))
	DB.setValue(nodeItem, 'acbak', 'number', DB.getValue(nodeItem, 'ac', 0))
	DB.setValue(nodeItem, 'checkpenaltybak', 'number', DB.getValue(nodeItem, 'checkpenalty', 0))
	
	local tDamagedWeapons = handleWeaponNodeArgs(nodeItem)
	for _,vNode in pairs(tDamagedWeapons) do
		DB.setValue(vNode, 'bonusbak', 'number', DB.getValue(vNode, 'bonus', 0))
		DB.setValue(vNode, 'critatkrangebak', 'number', DB.getValue(vNode, 'critatkrange', 20))
		for _,vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
			DB.setValue(vvNode, 'bonusbak', 'number', DB.getValue(vvNode, 'bonus', 0))
			DB.setValue(vvNode, 'critmultbak', 'number', DB.getValue(vvNode, 'critmult', 2))
		end
	end
end

function onBrokenChanged(node)
	local nodeItem = node.getParent()

	local nBrokenState = DB.getValue(nodeItem, 'broken', 0)
	if nBrokenState == 2 then
		if OptionsManager.isOption('DESTROY_ITEM', 'gone') then nodeItem.delete()
		elseif OptionsManager.isOption('DESTROY_ITEM', 'unequipped') then
			DB.setValue(nodeItem, 'carried', 'number', 0)
			DB.setValue(nodeItem, 'name', 'string', '[DESTROYED] ' .. DB.getValue(nodeItem, 'name', ''))
		end
	elseif nBrokenState == 1 then
		makeBackup(nodeItem)
		brokenPenalties(nodeItem, true)
	else
		brokenPenalties(nodeItem, false)
		removeBackup(nodeItem)
	end
end