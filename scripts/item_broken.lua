-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

function onInit()
	registerOptions()
end

function registerOptions()
	OptionsManager.registerOption2('DESTROY_ITEM', false, 'option_header_game', 'opt_lab_item_destroyed', 'option_entry_cycler', 
		{ labels = 'enc_opt_item_destroyed_gone', values = 'gone', baselabel = 'enc_opt_item_destroyed_unequipped', baseval = 'unequipped', default = 'unequipped' })
end

---	This function checks if the damaged weapon's name matches any in the actions tab and, if so, adds their locations to tDamagedWeapons.
--	@param nodeItem A databasenode pointing to the damaged item.
--	@param tDamagedWeapons An empty table to contain the actions tab locations of any matching weapons (so weapons with multiple listings like dagger or javelin are supported).
--	@return sItemName A string containing the name of the damaged item.
local function handleWeaponNodeArgs(nodeItem, tDamagedWeapons)
	local nodeChar = nodeItem.getChild('...')
	local sItemName = DB.getValue(nodeItem, 'name')
	
	for _,vNode in pairs(DB.getChildren(nodeChar, 'weaponlist')) do
		if sItemName == vNode.getChild('name').getValue() then
			table.insert(tDamagedWeapons, vNode)
		end
	end
	
	return sItemName
end

---	This function checks whether the weapon is broken or destroyed, and applies/removes the penalties.
--	To restore the penalties from a weapon, it parses the crit field and damage fields on the item sheet.
--	Weapon info entered in actions but not the item sheet will not be restored once the item is repaired.
--	If you need to edit your weapon, do so from the item sheet and toggle it from broken/repaired.
function brokenWeaponPenalties(nodeItem, nItemBrokenState)
	local tDamagedWeapons = {}
	local sItemName = handleWeaponNodeArgs(nodeItem, tDamagedWeapons)

	local nItemCritMult = 2
	local nItemCritRangeLower = 20
	local nItemMagicBonus = 0

	if DB.getValue(nodeItem, 'critical') ~= '' then
		local sItemCrit = DB.getValue(nodeItem, 'critical')
		local nItemCritEndPos = string.len(sItemCrit)
		local nItemCritMultPos = string.find(sItemCrit, '/', 2)
		if not nItemCritMultPos then
			local nItemCritMultPos = string.find(sItemCrit, 'x', 1)
				if not nItemCritMultPos then
					ChatManager.SystemMessage('Error, "' .. sItemName .. '" has crit data entered incorrectly.')
				else
					nItemCritMult = tonumber(string.sub(sItemCrit, nItemCritMultPos+1, nItemCritEndPos))
					nItemCritRangeLower = 20
				end
		else
			local sItemCritRange = string.sub(sItemCrit, 1, nItemCritMultPos-1)
			nItemCritRangeLower = tonumber(string.sub(sItemCritRange, 1, 2))
			nItemCritMult = tonumber(string.sub(sItemCrit, nItemCritMultPos+2, nItemCritEndPos-1))
		end
	end
	
	local nItemMagicBonus = DB.getValue(nodeItem, 'bonus.backup', 0)
	local sProperties = DB.getValue(nodeItem, 'properties', '')
	local bMwk = string.find(sProperties, 'masterwork', 1)
	local bMwkBonus = 0
	if bMwk and nItemMagicBonus == 0 then
		bMwkBonus = 1
	end

	if nItemBrokenState == 1 or nItemBrokenState == 2 then
		for _,v in pairs(tDamagedWeapons) do
			DB.setValue(v, 'bonus', 'number', nItemMagicBonus - 2 + bMwkBonus)
			DB.setValue(v, 'critatkrange', 'number', 20)
			
			for _,vv in pairs(DB.getChildren(v, 'damagelist')) do
				DB.setValue(vv, 'bonus', 'number', nItemMagicBonus - 2)
				if DB.getValue(vv, 'critmult', 2) > 1 then
					DB.setValue(vv, 'critmult', 'number', 2)
				end
			end
		end
	else
		for _,v in pairs(tDamagedWeapons) do
			DB.setValue(v, 'bonus', 'number', nItemMagicBonus + bMwkBonus)
			DB.setValue(v, 'critatkrange', 'number', nItemCritRangeLower)
			
			for _,vv in pairs(DB.getChildren(v, 'damagelist')) do
				DB.setValue(vv, 'bonus', 'number', nItemMagicBonus)
				DB.setValue(vv, 'critmult', 'number', nItemCritMult)
			end
		end
	end
end

---	This function backs up the original armor stats, checks whether the armor is broken or destroyed, and applies/removes the penalties.
--	Backed-up stats are ac, check penalty, and enhancement bonuses.
function brokenArmorPenalties(nodeItem, nItemBrokenState)
	local nodeChar = nodeItem.getChild('...')

	local nItemAc = DB.getValue(nodeItem, 'ac')
	local nItemAcBak = DB.getValue(nodeItem, 'ac.backup')
	local nItemCheckPen = DB.getValue(nodeItem, 'checkpenalty')
	local nItemCheckPenBak = DB.getValue(nodeItem, 'checkpenalty.backup')
	local nItemMagicBonus = DB.getValue(nodeItem, 'bonus', 0)
	local nItemMagicBonusBak = DB.getValue(nodeItem, 'bonus.backup')
	
	if not nItemAcBak then
		DB.setValue(nodeItem, 'ac.backup', 'number', nItemAc)
		nItemAcBak = DB.getValue(nodeItem, 'ac.backup')
	end
	if not nItemCheckPenBak then
		DB.setValue(nodeItem, 'checkpenalty.backup', 'number', nItemCheckPen)
		nItemCheckPenBak = DB.getValue(nodeItem, 'checkpenalty.backup')
	end
	if not nItemMagicBonusBak then
		DB.setValue(nodeItem, 'bonus.backup', 'number', nItemMagicBonus)
		nItemMagicBonusBak = DB.getValue(nodeItem, 'bonus.backup')
	end

	if nItemBrokenState == 1 or nItemBrokenState == 2 then
		DB.setValue(nodeItem, 'ac', 'number', math.floor(nItemAcBak / 2))
		DB.setValue(nodeItem, 'checkpenalty', 'number', nItemCheckPenBak * 2)
		DB.setValue(nodeItem, 'bonus', 'number', math.floor(nItemMagicBonusBak / 2))
		CharManager.calcItemArmorClass(DB.getChild(nodeItem, "..."))
	else
		DB.setValue(nodeItem, 'ac', 'number', nItemAcBak)
		DB.setValue(nodeItem, 'checkpenalty', 'number', nItemCheckPenBak)
		DB.setValue(nodeItem, 'bonus', 'number', nItemMagicBonusBak)
		CharManager.calcItemArmorClass(DB.getChild(nodeItem, "..."))
	end
end