--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
--	luacheck: globals calculateHHP miscHP miscHardness ItemManager.isArmor ItemManager.isWeapon

local function getSubstanceStats(sItemSubstance)
	if ItemDurabilityInfo and ItemDurabilityInfo.aMaterials and ItemDurabilityInfo.aMaterials[sItemSubstance] then
		return ItemDurabilityInfo.aMaterials[sItemSubstance]
	else
		return {}
	end
end

local function getItemHp(nodeItem, tSubstanceStats)

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

	local nArmorHpAc = getArmorHpFromAc(nodeItem)
	local nItemHpPerIn = tSubstanceStats.nItemHpPerIn or 0
	local nItemThickness = DB.getValue(nodeItem, 'thickness', 0)

	local nItemHp
	if ItemManager.isArmor(nodeItem) then
		nItemHp = (nArmorHpAc * (tSubstanceStats.nArmorHpMult or 1)) + (tSubstanceStats.nArmorHpBonus or 0)
	elseif ItemManager.isWeapon(nodeItem) then
		nItemHp = (nItemHpPerIn * nItemThickness * (tSubstanceStats.nWeaponHpMult or 1)) + (tSubstanceStats.nWeaponHpBonus or 0)
	else
		nItemHp = (nItemHpPerIn * nItemThickness)
	end
	nItemHp = nItemHp + miscHP(nodeItem)

	return nItemHp
end

local function getItemHardness(nodeItem, tSubstanceStats)
	local nItemHardness = tSubstanceStats.nHardness or 0
	nItemHardness = nItemHardness + miscHardness(nodeItem)

	return nItemHardness
end

function miscHP(nodeItem) -- luacheck: ignore
	return 0
end

function miscHardness(nodeItem) -- luacheck: ignore
	return 0
end

function calculateHHP(nodeItem)
	local tSubstanceStats = getSubstanceStats(DB.getValue(nodeItem, 'substance', ''):lower())

	local nItemEnhancementBonus = DB.getValue(nodeItem, 'bonus', 0)
	DB.setValue(nodeItem, 'hardness', 'number', math.floor(getItemHardness(nodeItem, tSubstanceStats) + (nItemEnhancementBonus * 2), nil))
	DB.setValue(nodeItem, 'hitpoints', 'number', math.floor(getItemHp(nodeItem, tSubstanceStats) + (nItemEnhancementBonus * 10), nil))
end
