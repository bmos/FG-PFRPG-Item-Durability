--
--	Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
--	luacheck: globals aMaterials
aMaterials = {
	-- materials from Special Materials list
	['abysium'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['angelskin'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 5 },
	['aszite'] = { ['nHardness'] = 15, ['nItemHpPerIn'] = 20 },
	['magic bridge basalt'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }, -- not sure about this hp/in figure
	['blight quartz'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 10 },
	['bone'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 12 }, -- I made up this nItemHpPerIn
	-- ['brass'] = { ['nHardness'] = 9, ['nItemHpPerIn'] = 0 },						-- This should exist, but doesn't
	['chitin'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 12 }, -- I made this up based on bone
	['coral'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 12 }, -- I made this up based on bone
	['cryptstone'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['blood crystal'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 10, ['nWeaponHpMult'] = 0.5 },
	['darkleaf cloth'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 20 },
	['darkwood'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 },
	['dragonhide'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 10 },
	-- hide of a dragon is typically between 1/2 inch and 1 inch thick
	['druchite'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 40 },
	['eel hide'] = { ['nHardness'] = 2, ['nItemHpPerIn'] = 5 },
	['elysian bronze'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	-- ['bronze'] = { ['nHardness'] = 9, ['nItemHpPerIn'] = 10 },
	-- bronze armor has hardness 9 and bronze weapons use the same hardness as their base weapon
	['gold'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 12 }, -- I made up this nItemHpPerIn
	['greenwood'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 },
	['griffon mane'] = { ['nHardness'] = 1, ['nItemHpPerIn'] = 2 },
	['horacalcum'] = { ['nHardness'] = 15, ['nItemHpPerIn'] = 30, ['nArmorHpMult'] = 1.25, ['nWeaponHpMult'] = 1.25 },
	['inubrix'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 },
	['cold iron'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['mindglass'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['noqual'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	-- ['obsidian'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	-- obsidian weapons have half the hardness of their base weapon
	['siccatite'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }, -- I made this up based on iron/steel
	['alchemical silver'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 }, -- I made this up based on iron/steel
	['silversheen'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 },
	['glaucite'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['spiresteel'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['net'] = { ['nHardness'] = 2, ['nItemHpPerIn'] = 5 }, -- I made this up based on leather
	['living steel'] = { ['nHardness'] = 15, ['nItemHpPerIn'] = 35 },
	['singing steel'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 20 },
	['sunsilver'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 },
	['silver'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 },
	-- This silver entry is a workaround because nobody says "alchemical silver" in their weapon names
	-- ['viridium'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10 },
	-- viridium weapons have half the hardness of their base weapon
	['voidglass'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['whipwood'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 10, ['nWeaponHpBonus'] = 5 },
	['wyroot'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 },

	-- substances from Damaging Items list
	['glass'] = { ['nHardness'] = 1, ['nItemHpPerIn'] = 1 },
	['paper'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 2 },
	['cloth'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 2 },
	['fabric'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 2 }, -- Just in case
	['rope'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 2 },
	['ice'] = { ['nHardness'] = 0, ['nItemHpPerIn'] = 3 },
	['leather'] = { ['nHardness'] = 2, ['nItemHpPerIn'] = 5 },
	['hide'] = { ['nHardness'] = 2, ['nItemHpPerIn'] = 5 },
	['wood'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 },
	['wooden'] = { ['nHardness'] = 5, ['nItemHpPerIn'] = 10 }, -- Just in case
	['stone'] = { ['nHardness'] = 8, ['nItemHpPerIn'] = 15 },
	['iron'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['steel'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 },
	['metal'] = { ['nHardness'] = 10, ['nItemHpPerIn'] = 30 }, -- This isn't accurate but it's ok
	['mithral'] = { ['nHardness'] = 15, ['nItemHpPerIn'] = 30 },
	['adamantine'] = { ['nHardness'] = 20, ['nItemHpPerIn'] = 40, ['nArmorHpMult'] = 1.33 },
}

--	luacheck: globals tItems
tItems = {
	-- adventuring supplies
	['vial'] = 'glass',
	['potion'] = 'glass',
	['scroll of'] = 'paper',
	['wand'] = 'wood',
	['torch'] = 'wood',
	['bottle'] = 'glass',
	['outfit'] = 'cloth',
	['bag'] = 'cloth',
	['backpack'] = 'cloth',
	['tent'] = 'cloth',

	-- weapons
	['sword'] = 'steel',
	['rapier'] = 'steel',
	['halberd'] = 'steel',
	['axe'] = 'steel',
	['dagger'] = 'steel',
	['quarterstaff'] = 'wood',
	['spear'] = 'wood',
	['club'] = 'wood',
	['mace'] = 'steel',
	['kukri'] = 'steel',
	['machete'] = 'steel',
	['knife'] = 'steel',
	['razor'] = 'steel',
	['sling'] = 'leather',

	-- armor
	['tunic'] = 'rope',
	['chain'] = 'steel',
	['plate'] = 'steel',
	['mail'] = 'steel',
	['buckler'] = 'steel',
	['tower'] = 'steel',
}

--	luacheck: globals tSizes
tSizes = {
	-- hitpoint multipliers for each size category
	['colossal'] = 16,
	['gargantuan'] = 8,
	['huge'] = 4,
	['large'] = 2,
	['medium'] = 1,
	['small'] = 0.5,
	['tiny'] = 0.25,
	['diminutive'] = 0.125,
	['fine'] = 0.0625,
}

---	This function fills the size and substance fields, if empty.
--	If the size field is empty and the item is held by a PC, its size is assumed to match the PC (otherwise medium).
--	If the substance field is empty, findSubstance() is called.
--	Once these pieces of information are known, they are written back to the item sheet.
--	@see findSubstance(nodeItem)
--	luacheck: globals fillAttributes
function fillAttributes(nodeItem)
	local sItemSize = DB.getValue(nodeItem, 'size', ''):lower()
	if sItemSize == '' then sItemSize = DB.getValue(nodeItem, '...size', 'medium'):lower() end
	DB.setValue(nodeItem, 'size', 'string', sItemSize)

	---	This function searches sItemProps, sItemName, and tItemParser for any of the keys in aSubstances.
	--	If it ever finds one, it stops searching and returns the key.
	--	If none of the materials in tItemParser are a match, it returns an empty string.
	--	@param nodeItem The item to be examined.
	--	@return sSubstance A string containing the material the item is most likely constructed of.
	local function findSubstance()
		local sSubstance = ''

		local function setSubstance(string, searchterm, material)
			if string:match(searchterm) then
				sSubstance = material
				return
			end
		end

		for kk, vv in pairs(tItems) do
			if setSubstance(DB.getValue(nodeItem, 'name', ''):lower(), kk, vv) then break end
		end
		for k, _ in pairs(aMaterials) do
			if setSubstance(DB.getValue(nodeItem, 'properties', ''):lower(), k, k) then break end
			if setSubstance(DB.getValue(nodeItem, 'name', ''):lower(), k, k) then break end
		end

		return sSubstance
	end

	if DB.getValue(nodeItem, 'substance', '') == '' then DB.setValue(nodeItem, 'substance', 'string', findSubstance()) end

	if DB.getValue(nodeItem, 'hardness', 0) == 0 and DB.getValue(nodeItem, 'hitpoints', 0) == 0 then ItemDurabilityHHP.calculateHHP(nodeItem) end
end
