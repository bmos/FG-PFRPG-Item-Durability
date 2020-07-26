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

function brokenWeaponPenalties(nodeItem, nItemnBrokenState)
	local tDamagedWeapons = {}
	local sItemName = handleWeaponNodeArgs(nodeItem, tDamagedWeapons)

	local nItemCritMult = 2
	local nItemCritRangeLower = 20
	local nItemBonus = 0

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
	
	local nItemBonus = DB.getValue(nodeItem, 'bonus')


	if nItemnBrokenState == 1 or nItemnBrokenState == 2 then
		for _,v in pairs(tDamagedWeapons) do
			DB.setValue(v, 'bonus', 'number', nItemBonus - 2)
			DB.setValue(v, 'critatkrange', 'number', 20)
			
			for _,vv in pairs(DB.getChildren(v, 'damagelist')) do
				DB.setValue(vv, 'bonus', 'number', nItemBonus - 2)
				DB.setValue(vv, 'critmult', 'number', 2)
			end
		end
	else
		for _,v in pairs(tDamagedWeapons) do
			DB.setValue(v, 'bonus', 'number', nItemBonus)
			DB.setValue(v, 'critatkrange', 'number', nItemCritRangeLower)
			
			for _,vv in pairs(DB.getChildren(v, 'damagelist')) do
				DB.setValue(vv, 'bonus', 'number', nItemBonus)
				DB.setValue(vv, 'critmult', 'number', nItemCritMult)
			end
		end
	end
end