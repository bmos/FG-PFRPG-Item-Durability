--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
--	luacheck: globals calculateHHP
function calculateHHP(nodeItem)

	local function getSubstanceStats(sItemSubstance)
		if ItemDurabilityInfo and ItemDurabilityInfo.aMaterials and ItemDurabilityInfo.aMaterials[sItemSubstance] then
			return ItemDurabilityInfo.aMaterials[sItemSubstance]
		else
			return {}
		end
	end

	local tSubstanceStats = getSubstanceStats(DB.getValue(nodeItem, 'substance', ''):lower())

	local function getItemHp()
		local nItemHp

		local function getTypes()
			local sItemType = DB.getValue(nodeItem, 'type', ''):lower()
			return sItemType:match('armor') ~= nil, sItemType:match('weapon') ~= nil
		end

		local function getArmorHpFromAc()
			local nArmorHpAc = DB.getValue(nodeItem, 'ac', 0) * 5
			local sItemSize = DB.getValue(nodeItem, 'size', ''):lower()
			for k, v in pairs(ItemDurabilityInfo.tSizes) do
				if k == sItemSize then
					nArmorHpAc = nArmorHpAc * v

					break
				end
			end
			return nArmorHpAc
		end

		local nArmorHpAc = getArmorHpFromAc()
		local nItemHpPerIn = tSubstanceStats.nItemHpPerIn or 0
		local nItemThickness = DB.getValue(nodeItem, 'thickness', 0)

		local bIsArmor, bIsWeapon = getTypes()
		if bIsArmor then
			nItemHp = (nArmorHpAc * (tSubstanceStats.nArmorHpMult or 1)) + (tSubstanceStats.nArmorHpBonus or 0)
		elseif bIsWeapon then
			nItemHp = (nItemHpPerIn * nItemThickness * (tSubstanceStats.nWeaponHpMult or 1)) + (tSubstanceStats.nWeaponHpBonus or 0)
		else
			nItemHp = (nItemHpPerIn * nItemThickness)
		end

		return nItemHp
	end

	local nItemEnhancementBonus = DB.getValue(nodeItem, 'bonus', 0)
	DB.setValue(nodeItem, 'hardness', 'number', math.floor((tSubstanceStats.nHardness or 0) + (nItemEnhancementBonus * 2), nil))
	DB.setValue(nodeItem, 'hitpoints', 'number', math.floor(getItemHp() + (nItemEnhancementBonus * 10), nil))
end
