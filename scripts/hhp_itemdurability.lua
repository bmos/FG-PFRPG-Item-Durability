-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

local function getSubstanceStats(sItemSubstance)
	local aSubstances = ItemDurabilityInfo.provideValues('materials')

	for k,v in pairs(aSubstances) do
		if k == sItemSubstance then
			return v
		end
	end
end

function calculateHHP(nodeItem)
	local sItemType = string.lower(DB.getValue(nodeItem, 'type', ''))
	local bIsArmor = false
	if sItemType:match('armor') then bIsArmor = true end
	local bIsWeapon = false
	if sItemType:match('weapon') then bIsWeapon = true end

	local nItemEnhancementBonus = DB.getValue(nodeItem, 'bonus', 0)
	
	local nItemHp = 0
	local nItemHpBonus = nItemEnhancementBonus * 10
	
	local nHardness = 0
	local nHardnessBonus = nItemEnhancementBonus * 2
	
	local nItemThickness = DB.getValue(nodeItem, 'thickness', 0)
	local nItemHpPerIn = 0

	local nWeaponHpMult = 1
	local nWeaponHpBonus = 0

	local nArmorHpMult = 1
	local nArmorHpBonus = 0

	local tSubstanceStats = getSubstanceStats(string.lower(DB.getValue(nodeItem, 'substance', '')))
	for k,v in pairs(tSubstanceStats) do
		Debug.chat(k, v)
		if k == 'nHardness' then nHardness = v
		elseif k == 'nItemHpPerIn' then nItemHpPerIn = v
		elseif k == 'nWeaponHpBonus' then nWeaponHpBonus = nWeaponHpBonus + v
		elseif k == 'nWeaponHpMult' then nWeaponHpMult = v
		elseif k == 'nArmorHpBonus' then nArmorHpBonus = nArmorHpBonus + v
		elseif k == 'nArmorHpMult' then nArmorHpMult = v
		end
	end
	
	local nArmorHpAc = DB.getValue(nodeItem, 'ac', 0) * 5
	
	local sItemSize = string.lower(DB.getValue(nodeItem, 'size', ''))
	local tSizeMult = ItemDurabilityInfo.provideValues('sizes')
	for k,v in pairs(tSizeMult) do
		if k == sItemSize then nArmorHpAc = nArmorHpAc * tSizeMult[k] end
		break
	end
	
	if bIsArmor then
		nItemHp = (nArmorHpAc * nArmorHpMult) + nArmorHpBonus
	elseif bIsWeapon then
		nItemHp = (nItemHpPerIn * nItemThickness * nWeaponHpMult) + nWeaponHpBonus
	else
		nItemHp =  (nItemHpPerIn * nItemThickness)
	end

	DB.setValue(nodeItem, 'hardness', 'number', ItemDurabilityLib.round(nHardness + nHardnessBonus, nil))
	DB.setValue(nodeItem, 'hitpoints', 'number', ItemDurabilityLib.round(nItemHp + nItemHpBonus, nil))
	
end