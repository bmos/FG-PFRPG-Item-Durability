-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

function onInit()
	onValueChanged()
end

local function provideValues(tSubstances, tSizeMult)
	tSubstances['glass'] = { ['nHardness'] = 1, ['nHpIn'] = 1 }
	tSubstances['paper'] = { ['nHardness'] = 0, ['nHpIn'] = 2 }
	tSubstances['cloth'] = { ['nHardness'] = 0, ['nHpIn'] = 2 }
	tSubstances['rope'] = { ['nHardness'] = 0, ['nHpIn'] = 2 }
	tSubstances['ice'] = { ['nHardness'] = 0, ['nHpIn'] = 3 }
	tSubstances['leather'] = { ['nHardness'] = 2, ['nHpIn'] = 5 }
	tSubstances['hide'] = { ['nHardness'] = 2, ['nHpIn'] = 5 }
	tSubstances['wood'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
	tSubstances['stone'] = { ['nHardness'] = 8, ['nHpIn'] = 15 }
	tSubstances['iron'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['steel'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['mithral'] = { ['nHardness'] = 15, ['nHpIn'] = 30 }
	tSubstances['adamantine'] = { ['nHardness'] = 20, ['nHpIn'] = 40 }
	
	tSizeMult['colossal'] = 16
	tSizeMult['gargantuan'] = 8
	tSizeMult['huge'] = 4
	tSizeMult['large'] = 2
	tSizeMult['medium'] = 1
	tSizeMult['small'] = 0.5
	tSizeMult['tiny'] = 0.25
	tSizeMult['diminutive'] = 0.125
	tSizeMult['fine'] = 0.0625
end

local function calcArmorHHP(sSubstance, tSubstances, tSizeMult, sCharSize)
	local nItemHpAc = window.ac.getValue() * 5
	local nItemHpBonus = window.bonus.getValue() * 10
	local nItemHp = nItemHpAc + nItemHpBonus

	local sItemSize = string.lower(window.size.getValue())
	if sItemSize == '' then
		sItemSize = sCharSize
		window.size.setValue(sItemSize)
	end
	for k,v in pairs(tSizeMult) do
		if k == sItemSize then
			nItemHp = nItemHp * tSizeMult[k]
		end
	end
	
	local nItemHardness = 0
	local nItemBonusHardness = window.bonus.getValue() * 2
	local sItemSubstance = window.substance.getValue()
	if sItemSubstance == '' then
		sItemSubstance = sSubstance
		window.substance.setValue(sItemSubstance)
	end
	for k,v in pairs(tSubstances) do
		if k == sItemSubstance then
			for kk,vv in pairs(v) do
				if kk == 'nHardness' then
					nItemHardness = vv + nItemBonusHardness
				end
			end
		end
	end
	
	if window.substance.getValue() and window.hitpoints.getValue() ~= nItemHp then
		window.hitpoints.setValue(math.floor(nItemHp))
	end
	
	if window.substance.getValue() and window.hardness.getValue() ~= nItemHardness then
		window.hardness.setValue(math.floor(nItemHardness))
	end
end

local function calcWeaponHHP(sSubstance, tSubstances, tSizeMult, sCharSize)
	local nItemHpPerIn = 0
	local nItemHardness = 0
	local sItemSubstance = window.substance.getValue()
	for k,v in pairs(tSubstances) do
		if k == sItemSubstance then
			for kk,vv in pairs(v) do
				if kk == 'nHardness' then
					nItemHardness = vv
				elseif kk == 'nHpIn' then
					nItemHpPerIn = vv
				end
			end
		end
	end

	local sItemSize = string.lower(window.size.getValue())
	if sItemSize == '' then
		sItemSize = sCharSize
		window.size.setValue(sItemSize)
	end
	for k,v in pairs(tSizeMult) do
		if k == sItemSize then
			nItemHpPerIn = nItemHpPerIn * tSizeMult[k]
		end
	end

	local nThickness = 0.125
	if window.thickness.getValue() then
		nThickness = window.thickness.getValue()
	end
	local nItemHp = nItemHpPerIn * nThickness 
	
	if window.substance.getValue() and window.hitpoints.getValue() ~= nItemHp then
		window.hitpoints.setValue(math.floor(nItemHp))
	end
	
	if window.substance.getValue() and window.hardness.getValue() ~= nItemHardness then
		window.hardness.setValue(math.floor(nItemHardness))
	end
end

local function calcItemHHP(sSubstance, tSubstances)
	local nItemHpPerIn = 0
	local nItemHardness = 0
	local sItemSubstance = window.substance.getValue()
	for k,v in pairs(tSubstances) do
		if k == sItemSubstance then
			for kk,vv in pairs(v) do
				if kk == 'nHardness' then
					nItemHardness = vv
				elseif kk == 'nHpIn' then
					nItemHpPerIn = vv
				end
			end
		end
	end

	local nThickness = 0
	if window.thickness.getValue() then
		nThickness = window.thickness.getValue()
	end
	local nItemHp = nItemHpPerIn * nThickness 
	
	if window.substance.getValue() and window.hitpoints.getValue() ~= nItemHp then
		window.hitpoints.setValue(math.floor(nItemHp))
	end
	
	if window.substance.getValue() and window.hardness.getValue() ~= nItemHardness then
		window.hardness.setValue(math.floor(nItemHardness))
	end
end

function checkItemName(sItemName, tSubstances)
	local sSubstance = ''
	
	for k,v in pairs(tSubstances) do
		if string.match(sItemName, k, 1) then
			sSubstance = k
		end
	end
	
	return sSubstance
end

--- This function assembles the data needed and passes it to the relevant functions.
--	First, it finds the name and type of the item.
--	Next, it requests the size multiplier (tSizeMult) and substance data (tSubstances) tables from provideValues()
--	Thirdly, it calls checkItemName() to look for substance clues in sItemName
--	Finally, it passes the relevant information to the applicable calculation formula based on sItemType
function onValueChanged()
	local sItemName = string.lower(DB.getValue(window.getDatabaseNode(), 'name', ''))
	local sItemType = string.lower(window.type.getValue())

	local sCharSize = string.lower(DB.getValue(window.getDatabaseNode().getChild('...'), 'size', 'medium'))
	
	local tSizeMult = {}
	local tSubstances = {}
	provideValues(tSubstances, tSizeMult)

	local sSubstance = checkItemName(sItemName, tSubstances)

	if sItemType == 'armor' then
		calcArmorHHP(sSubstance, tSubstances, tSizeMult, sCharSize)
	elseif sItemType == 'weapon' then
		calcArmorHHP(sSubstance, tSubstances, tSizeMult, sCharSize)
	else
		calcItemHHP(sSubstance, tSubstances)
	end
end