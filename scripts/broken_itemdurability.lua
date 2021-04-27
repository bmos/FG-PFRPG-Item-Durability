-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

---	This function checks if the damaged weapon's name matches any in the actions tab and, if so, adds their nodes to tDamagedWeapons.
--	@param nodeItem A databasenode pointing to the damaged item.
--	@return tDamagedWeapons A table of databasenodes pointing to the damaged item on the actions tab.
local function handleWeaponNodeArgs(nodeItem)
	local nodeChar = nodeItem.getChild('...')
	local sItemName = DB.getValue(nodeItem, 'name', '')
	local sUnbrokenItemName = sItemName:sub(10)
	
	local tDamagedWeapons = {}
	for _,nodeWeapon in pairs(DB.getChildren(nodeChar, 'weaponlist')) do
		if sItemName == DB.getValue(nodeWeapon, 'name', '') or sUnbrokenItemName == DB.getValue(nodeWeapon, 'name', '') then
			table.insert(tDamagedWeapons, nodeWeapon)
		end
	end
	
	return tDamagedWeapons
end

function brokenWeapon(nodeItem, bIsBroken)
	local tDamagedWeapons = handleWeaponNodeArgs(nodeItem)
	local sItemSubtype = string.lower(DB.getValue(nodeItem, 'subtype', ''))

	if bIsBroken then
		if not sItemSubtype:match('shield') then DB.setValue(nodeItem, 'bonus', 'number', DB.getValue(nodeItem, 'bonusbak', 0) - 2) end
		DB.setValue(nodeItem, 'critical', 'string', 'x2')
		for _,vNode in pairs(tDamagedWeapons) do
			DB.setValue(vNode, 'name', 'string', '[BROKEN] ' .. DB.getValue(vNode, 'name', ''))
			DB.setValue(vNode, 'bonus', 'number', DB.getValue(nodeItem, 'atkbonusbak', 0) - 2)
			DB.setValue(vNode, 'critatkrange', 'number', 20)
			
			for _,vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
				DB.setValue(vvNode, 'bonus', 'number', DB.getValue(nodeItem, 'dmgbonusbak', 0) - 2)
				if DB.getValue(vvNode, 'critmult', 2) > 2 then
					DB.setValue(vvNode, 'critmult', 'number', 2)
				end
			end
		end
	else
		if not sItemSubtype:match('shield') then DB.setValue(nodeItem, 'bonus', 'number', DB.getValue(nodeItem, 'bonusbak', 0)) end
		DB.setValue(nodeItem, 'critical', 'string', DB.getValue(nodeItem, 'criticalbak', 'x2'))
		for _,vNode in pairs(tDamagedWeapons) do
			local sItemName = DB.getValue(vNode, 'name', '')
			if sItemName:find('%[BROKEN%]') then DB.setValue(vNode, 'name', 'string', sItemName:sub(10)) end
			DB.setValue(vNode, 'bonus', 'number', DB.getValue(nodeItem, 'atkbonusbak', 0))
			DB.setValue(vNode, 'critatkrange', 'number', DB.getValue(nodeItem, 'critatkrangebak', 20))
			for _,vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
				DB.setValue(vvNode, 'bonus', 'number', DB.getValue(nodeItem, 'dmgbonusbak', 0))
				if DB.getValue(vvNode, 'critmultbak', 2) > 2 then
					DB.setValue(vvNode, 'critmult', 'number', DB.getValue(nodeItem, 'critmultbak', 2))
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

local function brokenItemCost(nodeItem, bIsBroken)
	local sItemCostBak = DB.getValue(nodeItem, 'costbak', '')

	if bIsBroken and sItemCostBak ~= '' then
		sItemCostBak = sItemCostBak:gsub(',+', '')
		sItemCostBak = sItemCostBak:gsub('%s+', '')
		
		local sItemCostSeperatorChar = string.match(sItemCostBak, '[%D]')
		local nItemCostSeperator = string.find(sItemCostBak, sItemCostSeperatorChar)
		
		local nItemCostNew = tonumber(string.sub(sItemCostBak, 1, nItemCostSeperator - 1))
		local sItemCostUnit = string.sub(sItemCostBak, nItemCostSeperator)
		
		DB.setValue(nodeItem, 'cost', 'string', ItemDurabilityLib.round(nItemCostNew * .75, nil) .. ' ' .. sItemCostUnit)
	elseif not bIsBroken then
		DB.setValue(nodeItem, 'cost', 'string', DB.getValue(nodeItem, 'costbak', ''))
	end
end

function brokenPenalties(nodeItem, bIsBroken)
	brokenItemCost(nodeItem, bIsBroken)
	local sItemType = string.lower(DB.getValue(nodeItem, 'type', ''))
	if sItemType:match('weapon') then brokenWeapon(nodeItem, bIsBroken) end
	if sItemType:match('armor') then brokenArmor(nodeItem, bIsBroken) end
	local sItemSubtype = string.lower(DB.getValue(nodeItem, 'subtype', ''))
	if sItemSubtype:match('shield') and StringManager.contains(Extension.getExtensions(), 'Advanced Character Inventory Manager for 3.5E and Pathfinder') then brokenWeapon(nodeItem, bIsBroken) end
end

local function removeBackup(nodeItem)
	if DB.getValue(nodeItem, 'costbak') then nodeItem.getChild('costbak').delete() end
	
	if DB.getValue(nodeItem, 'bonusbak') then nodeItem.getChild('bonusbak').delete() end
	if DB.getValue(nodeItem, 'acbak') then nodeItem.getChild('acbak').delete() end
	if DB.getValue(nodeItem, 'checkpenaltybak') then nodeItem.getChild('checkpenaltybak').delete() end

	if DB.getValue(nodeItem, 'damagebak') then nodeItem.getChild('damagebak').delete() end
	if DB.getValue(nodeItem, 'criticalbak') then nodeItem.getChild('criticalbak').delete() end

	if DB.getValue(nodeItem, 'atkbonusbak') then nodeItem.getChild('atkbonusbak').delete() end
	if DB.getValue(nodeItem, 'critatkrangebak') then nodeItem.getChild('critatkrangebak').delete() end

	if DB.getValue(nodeItem, 'dmgbonusbak') then nodeItem.getChild('dmgbonusbak').delete() end
	if DB.getValue(nodeItem, 'critmultbak') then nodeItem.getChild('critmultbak').delete() end
end

local function makeBackup(nodeItem)
	DB.setValue(nodeItem, 'costbak', 'string', DB.getValue(nodeItem, 'cost', ''))
	
	DB.setValue(nodeItem, 'bonusbak', 'number', DB.getValue(nodeItem, 'bonus', 0))
	DB.setValue(nodeItem, 'acbak', 'number', DB.getValue(nodeItem, 'ac', 0))
	DB.setValue(nodeItem, 'checkpenaltybak', 'number', DB.getValue(nodeItem, 'checkpenalty', 0))
	
	DB.setValue(nodeItem, 'damagebak', 'string', DB.getValue(nodeItem, 'damage', ''))
	DB.setValue(nodeItem, 'criticalbak', 'string', DB.getValue(nodeItem, 'critical', 'x2'))
	local tDamagedWeapons = handleWeaponNodeArgs(nodeItem)
	for _,vNode in pairs(tDamagedWeapons) do
		DB.setValue(nodeItem, 'atkbonusbak', 'number', DB.getValue(vNode, 'bonus', 0))
		DB.setValue(nodeItem, 'critatkrangebak', 'number', DB.getValue(vNode, 'critatkrange', 20))
		for _,vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
			DB.setValue(nodeItem, 'dmgbonusbak', 'number', DB.getValue(vvNode, 'bonus', 0))
			DB.setValue(nodeItem, 'critmultbak', 'number', DB.getValue(vvNode, 'critmult', 2))
		end
	end
end

function handleBrokenItem(nodeItem)
	local sItemName = DB.getValue(nodeItem, 'name', '')
	if sItemName ~= '' then
		local nBrokenState = DB.getValue(nodeItem, 'broken', 0)
		if nBrokenState == 2 and not sItemName:find('%[DESTROYED%]') then
			if OptionsManager.isOption('DESTROY_ITEM', 'gone') then
				nodeItem.delete()
			elseif OptionsManager.isOption('DESTROY_ITEM', 'unequipped') then
				DB.setValue(nodeItem, 'carried', 'number', 0)
				DB.setValue(nodeItem, 'name', 'string', '[DESTROYED] ' .. DB.getValue(nodeItem, 'name', ''))
			end
		elseif nBrokenState == 1 and not sItemName:find('%[BROKEN%]') then
			makeBackup(nodeItem)
			brokenPenalties(nodeItem, true)
			DB.setValue(nodeItem, 'name', 'string', '[BROKEN] ' .. DB.getValue(nodeItem, 'name', ''))
		else
			brokenPenalties(nodeItem, false)
			removeBackup(nodeItem)
			if sItemName:find('%[BROKEN%]') then DB.setValue(nodeItem, 'name', 'string', sItemName:sub(10)) end
		end
	end
end

local function onBrokenChanged(node)
	local nodeItem = node.getParent()
	handleBrokenItem(nodeItem)
end

function onInit()
	if Session.IsHost then
		DB.addHandler(DB.getPath('charsheet.*.inventorylist.*.broken'), 'onUpdate', onBrokenChanged)
	end
	
	OptionsManager.registerOption2('DESTROY_ITEM', false, 'option_header_game', 'opt_lab_item_destroyed', 'option_entry_cycler', 
		{ labels = 'enc_opt_item_destroyed_gone', values = 'gone', baselabel = 'enc_opt_item_destroyed_unequipped', baseval = 'unequipped', default = 'unequipped' })
end