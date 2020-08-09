-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

--- This function adds stored information to the supplied tables/arrays.
--	@param sK The data being requested.
function provideValues(sK)
	local t = {}

	if sK == 'materials' then
		-- materials from Special Materials list
		t['abysium'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['angelskin'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 5 }
		t['aszite'] = { ['nHardness'] = 15, ['nItemHpPerIn'] = 20 }
		t['magic bridge basalt'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }	-- not sure about this hp/in figure
		t['blight quartz'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 10 }
		t['bone'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 12 }			-- I made up this nItemHpPerIn
	--	t['brass'] = { ['nHardness'] = 9, ['nItemHpPerIn'] = 0 }			-- This should exist, but doesn't
		t['chitin'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 12 }		-- I made this up based on bone
		t['coral'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 12 }		-- I made this up based on bone
		t['cryptstone'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['blood crystal'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 10, ['nWeaponHpMult'] = 0.5 }
		t['darkleaf cloth'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 20 }
		t['darkwood'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 }
		t['dragonhide'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 10 }	-- hide of a dragon is typically between 1/2 inch and 1 inch thick
		t['druchite'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 40 }
		t['eel hide'] = { ['nHardness'] = 2, ['nItemHpPerIn'] = 5 }
		t['elysian bronze'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
	--	t['bronze'] = { ['nHardness'] = 9, ['nItemHpPerIn'] = 10 }		-- bronze armor has hardness 9 and bronze weapons use the same hardness as their base weapon
		t['gold'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 12 }			-- I made up this nItemHpPerIn
		t['greenwood'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 }
		t['griffon mane'] = { ['nHardness'] = 1, ['nItemHpPerIn'] = 2 }
		t['horacalcum'] = { ['nHardness'] = 15, ['nItemHpPerIn'] = 30, ['nArmorHpMult'] = 1.25, ['nWeaponHpMult'] = 1.25 }
		t['inubrix'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 }
		t['cold iron'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['mindglass'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['noqual'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
	--	t['obsidian'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }	-- obsidian weapons have half the hardness of their base weapon 
		t['siccatite'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }	-- I made this up based on iron/steel
		t['alchemical silver'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 }	-- I made this up based on iron/steel
		t['silversheen'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 }
		t['glaucite'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['spiresteel'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['net'] = { ['nHardness'] = 2, ['nItemHpPerIn'] = 5 }			-- I made this up based on leather
		t['living steel'] = { ['nHardness'] = 15, ['nItemHpPerIn'] = 35 }
		t['singing steel'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 20 }
		t['sunsilver'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 }
		t['silver'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 }		-- This is a workaround because nobody says "alchemical silver" in their weapon names
	--	t['viridium'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 }		-- viridium weapons have half the hardness of their base weapon 
		t['voidglass'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['whipwood'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10, ['nWeaponHpBonus'] = 5 }
		t['voidglass'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['wyroot'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 }
		
		-- substances from Damaging Items list
		t['glass'] = { ['nHardness'] = 1, ['nItemHpPerIn'] = 1 }
		t['paper'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 2 }
		t['cloth'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 2 }
		t['fabric'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 2 }		-- Just in case
		t['rope'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 2 }
		t['ice'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 3 }
		t['leather'] = { ['nHardness'] = 2, ['nItemHpPerIn'] = 5 }
		t['hide'] = { ['nHardness'] = 2, ['nItemHpPerIn'] = 5 }
		t['wood'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 }
		t['wooden'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 }		-- Just in case
		t['stone'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 15 }
		t['iron'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['steel'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }
		t['metal'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }		-- This is an oversimplification, but I think it's warranted
		t['mithral'] = { ['nHardness'] = 15, ['nItemHpPerIn'] = 30 }
		t['adamantine'] = { ['nHardness'] = 20, ['nItemHpPerIn'] = 40, ['nArmorHpMult'] = 1.33 }
	end

	if sK == 'items' then
		-- aventuring supplies
		t['vial'] = 'glass'
		t['potion'] = 'glass'
		t['scroll of'] = 'paper'
		t['wand'] = 'wood'
		t['torch'] = 'wood'
		t['bottle'] = 'glass'
		t['outfit'] = 'cloth'
		t['bag'] = 'cloth'
		t['backpack'] = 'cloth'
		t['tent'] = 'cloth'

		-- weapons
		t['sword'] = 'steel'
		t['axe'] = 'steel'
		t['dagger'] = 'steel'
		t['quarterstaff'] = 'wood'
		t['spear'] = 'wood'
		t['club'] = 'wood'
		t['mace'] = 'steel'
		t['kukri'] = 'steel'
		t['machete'] = 'steel'
		t['knife'] = 'steel'
		t['razor'] = 'steel'
		t['sling'] = 'leather'

		-- armor
		t['tunic'] = 'rope'
		t['chain'] = 'steel'
		t['plate'] = 'steel'
		t['mail'] = 'steel'
		t['buckler'] = 'steel'
		t['tower'] = 'steel'
	end

	if sK == 'sizes' then
		-- hitpoint multipliers for each size category
		t['colossal'] = 16
		t['gargantuan'] = 8
		t['huge'] = 4
		t['large'] = 2
		t['medium'] = 1
		t['small'] = 0.5
		t['tiny'] = 0.25
		t['diminutive'] = 0.125
		t['fine'] = 0.0625
	end
	
	return t
end

---	This function searches sItemProps, sItemName, and tItemParser for any of the keys in aSubstances.
--	If it ever finds one, it stops searching and returns the key.
--	If none of the materials in tItemParser are a match, it returns an empty string.
--	@param nodeItem The item to be examined.
--	@see provideValues(nR, t)
--	@return sSubstance A string containing the material the item is most likely constructed of.
local function findSubstance(nodeItem)
	local sSubstance = ''
	local sItemName = string.lower(DB.getValue(nodeItem, 'name', ''))
	local sItemProps = string.lower(DB.getValue(nodeItem, 'properties', ''))

	local aSubstances = provideValues('materials')
	local tItemParser = provideValues('items')
		
	for k,_ in pairs(aSubstances) do
		if sItemProps:match(k) then
			sSubstance = k
			break
		end
		if sItemName:match(k) then
			sSubstance = k
			break
		end
	end
	if sSubstance == '' then
		for k,v in pairs(tItemParser) do
			if sItemName:match(k) then
				sSubstance = v
				break
			end
		end
	end

	return sSubstance
end

---	This function fills the size and substance fields, if empty.
--	If the size field is empty and the item is held by a PC, its size is assumed to match the PC (otherwise medium).
--	If the substance field is empty, findSubstance() is called.
--	Once these pieces of information are known, they are written back to the item sheet.
--	@see findSubstance(nodeItem)
function fillAttributes(nodeItem)
	local sCharSize = string.lower(DB.getValue(nodeItem.getChild('...'), 'size', 'medium'))
	local sItemSize = string.lower(DB.getValue(nodeItem, 'size', ''))
	if sItemSize == '' then sItemSize = sCharSize end
	DB.setValue(nodeItem, 'size', 'string', sItemSize)

	local sItemSubstance = string.lower(DB.getValue(nodeItem, 'substance', ''))
	if sItemSubstance == '' then
		DB.setValue(nodeItem, 'substance', 'string', findSubstance(nodeItem))
	end
	
	if DB.getValue(nodeItem, 'hardness', 0) == 0 and DB.getValue(nodeItem, 'hitpoints', 0) == 0 then ItemDurabilityHHP.calculateHHP(nodeItem) end
end