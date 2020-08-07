-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

--- This function adds stored information to the supplied tables/arrays.
--	@param aSubstances This is an empty array to add material names and their info tables to.
--	@param tSizeMult This is an empty table to add the size categories and their hitpoint multipliers to.
--	@param tItemParser This is an empty table to add the item names and their associated materials to.
function provideValues(aSubstances, tSizeMult, tItemParser)	
		-- materials from Special Materials list
	if aSubstances == {} then
		aSubstances['abysium'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['angelskin'] = { ['nHardness'] = 5, ['nHpIn'] = 5 }
		aSubstances['aszite'] = { ['nHardness'] = 15, ['nHpIn'] = 20 }
		aSubstances['magic bridge basalt'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }	-- not sure about this hp/in figure
		aSubstances['blight quartz'] = { ['nHardness'] = 10, ['nHpIn'] = 10 }
		aSubstances['bone'] = { ['nHardness'] = 5, ['nHpIn'] = 12 }			-- I made up this nHpIn
	--	aSubstances['brass'] = { ['nHardness'] = 9, ['nHpIn'] = 0 }			-- This should exist, but doesn't
		aSubstances['chitin'] = { ['nHardness'] = 5, ['nHpIn'] = 12 }		-- I made this up based on bone
		aSubstances['coral'] = { ['nHardness'] = 5, ['nHpIn'] = 12 }		-- I made this up based on bone
		aSubstances['cryptstone'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['blood crystal'] = { ['nHardness'] = 10, ['nHpIn'] = 10, ['nWeaponHpMult'] = 0.5 }
		aSubstances['darkleaf cloth'] = { ['nHardness'] = 10, ['nHpIn'] = 20 }
		aSubstances['darkwood'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
		aSubstances['dragonhide'] = { ['nHardness'] = 10, ['nHpIn'] = 10 }	-- hide of a dragon is typically between 1/2 inch and 1 inch thick
		aSubstances['druchite'] = { ['nHardness'] = 10, ['nHpIn'] = 40 }
		aSubstances['eel hide'] = { ['nHardness'] = 2, ['nHpIn'] = 5 }
		aSubstances['elysian bronze'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	--	aSubstances['bronze'] = { ['nHardness'] = 9, ['nHpIn'] = 10 }		-- bronze armor has hardness 9 and bronze weapons use the same hardness as their base weapon
		aSubstances['gold'] = { ['nHardness'] = 5, ['nHpIn'] = 12 }			-- I made up this nHpIn
		aSubstances['greenwood'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
		aSubstances['griffon mane'] = { ['nHardness'] = 1, ['nHpIn'] = 2 }
		aSubstances['horacalcum'] = { ['nHardness'] = 15, ['nHpIn'] = 30, ['nArmorHpMult'] = 1.25, ['nWeaponHpMult'] = 1.25 }
		aSubstances['inubrix'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
		aSubstances['cold iron'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['mindglass'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['noqual'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	--	aSubstances['obsidian'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }	-- obsidian weapons have half the hardness of their base weapon 
		aSubstances['siccatite'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }	-- I made this up based on iron/steel
		aSubstances['alchemical silver'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }	-- I made this up based on iron/steel
		aSubstances['silversheen'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }
		aSubstances['glaucite'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['spiresteel'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['net'] = { ['nHardness'] = 2, ['nHpIn'] = 5 }			-- I made this up based on leather
		aSubstances['living steel'] = { ['nHardness'] = 15, ['nHpIn'] = 35 }
		aSubstances['singing steel'] = { ['nHardness'] = 10, ['nHpIn'] = 20 }
		aSubstances['sunsilver'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }
		aSubstances['silver'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }		-- This is a workaround because nobody says "alchemical silver" in their weapon names
	--	aSubstances['viridium'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }		-- viridium weapons have half the hardness of their base weapon 
		aSubstances['voidglass'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['whipwood'] = { ['nHardness'] = 8, ['nHpIn'] = 10, ['nWeaponHpBonus'] = 5 }
		aSubstances['voidglass'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['wyroot'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
		
		-- substances from Damaging Items list
		aSubstances['glass'] = { ['nHardness'] = 1, ['nHpIn'] = 1 }
		aSubstances['paper'] = { ['nHardness'] = 0, ['nHpIn'] = 2 }
		aSubstances['cloth'] = { ['nHardness'] = 0, ['nHpIn'] = 2 }
		aSubstances['fabric'] = { ['nHardness'] = 0, ['nHpIn'] = 2 }		-- Just in case
		aSubstances['rope'] = { ['nHardness'] = 0, ['nHpIn'] = 2 }
		aSubstances['ice'] = { ['nHardness'] = 0, ['nHpIn'] = 3 }
		aSubstances['leather'] = { ['nHardness'] = 2, ['nHpIn'] = 5 }
		aSubstances['hide'] = { ['nHardness'] = 2, ['nHpIn'] = 5 }
		aSubstances['wood'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
		aSubstances['wooden'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }		-- Just in case
		aSubstances['stone'] = { ['nHardness'] = 8, ['nHpIn'] = 15 }
		aSubstances['iron'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['steel'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
		aSubstances['metal'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }		-- This is an oversimplification, but I think it's warranted
		aSubstances['mithral'] = { ['nHardness'] = 15, ['nHpIn'] = 30 }
		aSubstances['adamantine'] = { ['nHardness'] = 20, ['nHpIn'] = 40, ['nArmorHpMult'] = 1.33 }
	end

	if tSizeMult == {} then
		-- hitpoint multipliers for each size category
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
	
	if tItemParser == {} then
		-- aventuring supplies
		tItemParser['vial'] = 'glass'
		tItemParser['potion'] = 'glass'
		tItemParser['scroll of'] = 'paper'
		tItemParser['wand'] = 'wood'
		tItemParser['torch'] = 'wood'
		tItemParser['bottle'] = 'glass'
		tItemParser['outfit'] = 'cloth'
		tItemParser['bag'] = 'cloth'
		tItemParser['backpack'] = 'cloth'
		tItemParser['tent'] = 'cloth'

		-- weapons
		tItemParser['sword'] = 'steel'
		tItemParser['axe'] = 'steel'
		tItemParser['dagger'] = 'steel'
		tItemParser['quarterstaff'] = 'wood'
		tItemParser['spear'] = 'wood'
		tItemParser['club'] = 'wood'
		tItemParser['mace'] = 'steel'
		tItemParser['kukri'] = 'steel'
		tItemParser['machete'] = 'steel'
		tItemParser['knife'] = 'steel'
		tItemParser['razor'] = 'steel'
		tItemParser['sling'] = 'leather'

		-- armor
		tItemParser['tunic'] = 'rope'
		tItemParser['chain'] = 'steel'
		tItemParser['plate'] = 'steel'
		tItemParser['mail'] = 'steel'
		tItemParser['buckler'] = 'steel'
		tItemParser['tower'] = 'steel'
	end
end