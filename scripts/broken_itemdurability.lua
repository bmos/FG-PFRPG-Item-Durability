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
--	@return sItemName A string containing the name of the damaged item.
local function handleWeaponNodeArgs(nodeItem)
	local nodeChar = nodeItem.getChild('...')
	local sItemName = DB.getValue(nodeItem, 'name')
	
	local tDamagedWeapons = {}
	for _,vNode in pairs(DB.getChildren(nodeChar, 'weaponlist')) do
		if sItemName == vNode.getChild('name').getValue() then
			table.insert(tDamagedWeapons, vNode)
		end
	end
	
	return tDamagedWeapons
end

local function applyBrokenPenalties(nodeItem, nBrokenState)
end

local function removeBackup(nodeItem)
	if DB.getValue(nodeItem, 'costbak') then nodeItem.getChild('costbak').delete() end
	if DB.getValue(nodeItem, 'bonusbak') then nodeItem.getChild('bonusbak').delete() end
	if DB.getValue(nodeItem, 'acbak') then nodeItem.getChild('acbak').delete() end
	
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
			DB.setValue(nodeItem, 'name', 'string', '[DESTROYED]' .. DB.getValue(nodeItem, 'name', ''))
		end
	elseif nBrokenState == 1 then
		makeBackup(nodeItem)
		applyBrokenPenalties(nodeItem, nBrokenState)
	else
		removeBackup(nodeItem)
	end
end