-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

local function handleWeaponNodeArgs(nodeItem, tDamagedWeapons)
	local nodeChar = nodeItem.getChild('...')
	local sItemName = DB.getValue(nodeItem, 'name')
	
	for k,v in pairs(DB.getChildren(nodeChar, 'weaponlist')) do
		if sItemName == v.getChild('name').getValue() then
			table.insert(tDamagedWeapons, v)
		end
	end
	
	return sItemName
end

function brokenWeaponPenalties(nodeItem, nItemBrokenState)
	local tDamagedWeapons = {}
	local sItemName = handleWeaponNodeArgs(nodeItem, tDamagedWeapons)

	local nItemCritMult = 2
	local nItemCritRangeLower = 20
	local nItemMagicBonus = 0

	if DB.getValue(nodeItem, 'critical') ~= '' then
		local sItemCrit = DB.getValue(nodeItem, 'critical')
		sItemCrit = sItemCrit .. '☹'
		local nItemCritEndPos = string.find(sItemCrit, '☹', 2)
		local nItemCritMultPos = string.find(sItemCrit, '/', 2)
		if not nItemCritMultPos then
			ChatManager.SystemMessage('Error, "' .. sItemName .. '" has crit data entered incorrectly.')
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