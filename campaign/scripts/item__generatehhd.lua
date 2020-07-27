-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

---	This function triggers when the substance, thickness, and size fields are loaded on the item sheet.
--	This provides an opportunity to initiate onValueChanged() to configure the values before the sheet is drawn for viewing.
--	@see onValueChanged()
function onInit()
	onValueChanged()
end

--- This function adds stored information to the supplied tables.
--	First, it creates a cascading array of tables in tSubstances containing the properties of supported material types keyed to their names.
--	Then, it fills tSizeMult with the item hitpoint multipliers keyed to their size categories.
--	@param tSubstances This is an empty table to add material names and their info tables to.
--	@param tSizeMult This is an empty table to add the size categories and their hitpoint multipliers to.
local function provideValues(tSubstances, tSizeMult)	
	-- materials from Special Materials list
	tSubstances['abysium'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['angelskin'] = { ['nHardness'] = 5, ['nHpIn'] = 5 }
	tSubstances['aszite'] = { ['nHardness'] = 15, ['nHpIn'] = 20 }
	tSubstances['magic bridge basalt'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }	-- not sure about this hp per in figure
	tSubstances['blight quartz'] = { ['nHardness'] = 10, ['nHpIn'] = 10 }
	tSubstances['bone'] = { ['nHardness'] = 5, ['nHpIn'] = 12 }			-- I made up this nHpIn
--	tSubstances['brass'] = { ['nHardness'] = 9, ['nHpIn'] = 0 }			-- This should exist, but doesn't
	tSubstances['chitin'] = { ['nHardness'] = 5, ['nHpIn'] = 12 }		-- I made this up based on bone
	tSubstances['coral'] = { ['nHardness'] = 5, ['nHpIn'] = 12 }		-- I made this up based on bone
	tSubstances['cryptstone'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['blood crystal'] = { ['nHardness'] = 10, ['nHpIn'] = 10 }
	tSubstances['darkleaf cloth'] = { ['nHardness'] = 10, ['nHpIn'] = 20 }
	tSubstances['darkwood'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
	tSubstances['dragonhide'] = { ['nHardness'] = 10, ['nHpIn'] = 10 }	-- hide of a dragon is typically between 1/2 inch and 1 inch thick
	tSubstances['druchite'] = { ['nHardness'] = 10, ['nHpIn'] = 40 }
	tSubstances['eel hide'] = { ['nHardness'] = 2, ['nHpIn'] = 5 }
	tSubstances['elysian bronze'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
--	tSubstances['bronze'] = { ['nHardness'] = 9, ['nHpIn'] = 10 }		-- bronze armor has hardness 9 and bronze weapons use the same hardness as their base weapon
	tSubstances['gold'] = { ['nHardness'] = 5, ['nHpIn'] = 12 }			-- I made up this nHpIn
	tSubstances['greenwood'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
	tSubstances['griffon mane'] = { ['nHardness'] = 1, ['nHpIn'] = 2 }
	tSubstances['horacalcum'] = { ['nHardness'] = 15, ['nHpIn'] = 30 }
	tSubstances['inubrix'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
	tSubstances['cold iron'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['mindglass'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['noqual'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
--	tSubstances['obsidian'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }	-- obsidian weapons have half the hardness of their base weapon 
	tSubstances['siccatite'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }	-- I made this up based on iron/steel
	tSubstances['alchemical silver'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }	-- I made this up based on iron/steel
	tSubstances['silversheen'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }
	tSubstances['glaucite'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['spiresteel'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['net'] = { ['nHardness'] = 2, ['nHpIn'] = 5 }			-- I made this up based on leather
	tSubstances['living steel'] = { ['nHardness'] = 15, ['nHpIn'] = 35 }
	tSubstances['singing steel'] = { ['nHardness'] = 10, ['nHpIn'] = 20 }
	tSubstances['sunsilver'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }
	tSubstances['silver'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }		-- This is a workaround because nobody says "alchemical silver" in their weapon names
--	tSubstances['viridium'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }		-- viridium weapons have half the hardness of their base weapon 
	tSubstances['voidglass'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['whipwood'] = { ['nHardness'] = 8, ['nHpIn'] = 10 }
	tSubstances['voidglass'] = { ['nHardness'] = 10, ['nHpIn'] = 30 }
	tSubstances['wyroot'] = { ['nHardness'] = 5, ['nHpIn'] = 10 }
	
	-- substances from Damaging Items list
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

---	This function calculates the hardness and hitpoints of armor-type items.
--	To do this, it collects some final information and performs armor-specific hardness and hitpoint calculation (such as ignoring thickness).
--	Once the values have been processed, it writes them back to the fields on the item sheet if they have changed.
--	@param sSubstance This string contains the name of the most likely substance that the armor could be made of.
--	@param tSubstances This table contains material info tables keyed to the material names.
--	@param tSizeMult This table contains the hitpoint multipliers keyed to their size categories.
--	@param sCharSize This string contains the character's size, for use if the armor size has not yet been set.
local function calcArmorHHP(sSubstance, tSubstances, tSizeMult, sCharSize)
	local nItemHpAc = window.ac.getValue() * 5
	local nItemHpBonus = window.bonus.getValue() * 10
	local nItemHp = nItemHpAc + nItemHpBonus

	local sItemSize = string.lower(window.size.getValue())
	if sItemSize == '' then			-- if item has no size assigned, use character size
		sItemSize = sCharSize
		window.size.setValue(sItemSize)
	end
	for k,v in pairs(tSizeMult) do	-- check item size against size multipliers
		if k == sItemSize then		-- if found, multiply item hitpoints by the size multipler
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

---	This function calculates the hardness and hitpoints of weapon-type items.
--	To do this, it collects some final information and performs weapon-specific hardness and hitpoint calculation (such as allowing for thickness).
--	If the resulting numbers are different than what is listed on the item sheet, it writes them back to the fields on the item sheet.
--	@param sSubstance This string contains the name of the most likely substance that the weapon could be made of.
--	@param tSubstances This table contains material info tables keyed to the material names.
--	@param tSizeMult This table contains the hitpoint multipliers keyed to their size categories.
--	@param sCharSize This string contains the character's size, for use if the weapon's size has not yet been set.
local function calcWeaponHHP(sSubstance, tSubstances, tSizeMult, sCharSize)
	local nItemHpPerIn = 0
	local nItemHardness = 0
	local sItemSubstance = window.substance.getValue()
	if sItemSubstance == '' then
		sItemSubstance = sSubstance
		window.substance.setValue(sItemSubstance)
	end
	
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

---	This function calculates the hardness and hitpoints of non-weapon, non-armor -type items.
--	To do this, it collects some final information and performs generic hardness and hitpoint calculation (allowing for thickness but not adjusting for size).
--	If the resulting numbers are different than what is listed on the item sheet, it writes them back to the fields on the item sheet.
--	@param sSubstance This string contains the name of the most likely substance that the item could be made of.
--	@param tSubstances This table contains material info tables keyed to the material names.
local function calcItemHHP(sSubstance, tSubstances)
	local nItemHpPerIn = 0
	local nItemHardness = 0
	local sItemSubstance = window.substance.getValue()
	if sItemSubstance == '' then
		sItemSubstance = sSubstance
		window.substance.setValue(sItemSubstance)
	end
	
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

--- This function creates a cascading array of tables pairing material names with their properties
--	The top level of the table is a list of tables keyed to the name of the material whose properties they contain
--	@param tSubstances This is an empty table to fill with material info tables
--	@param tSizeMult This is an empty table to fill with the various size categories paired with their item hitpoint multipliers
local function parseSpecificItems(tItemParser)
	-- aventuring supplies
	tItemParser['vial'] = 'glass'
	tItemParser['potion'] = 'glass'
	tItemParser['scroll of'] = 'paper'
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

---	This function searches sItemName and sItemProps for any of the keys in aSubstances.
--	If it ever finds one, it stops searching and returns the key.
--	First, it searches sItemProps for any of the material-name keys in aSubstances.
--	If none of the materials are found in sItemProps, it checks sItemName for the same list of materials, along with the item-name keys in tItemParser.
--	If none of the materials in tItemParser are a match, it returns an empty string.
--	@param sItemName A string contining the full name of the item being checked.
--	@param sItemProps A string contining the full properties string of the item being checked.
--	@param aSubstances An array contining tables of properties keyed to the name of the materials they describe.
--	@see parseSpecificItems(tItemParser)
--	@return sSubstance A string containing the first material name found in sItemName.
local function checkItemMaterial(sItemName, sItemProps, aSubstances)
	local sSubstance = ''
	
	local tItemParser = {}
	parseSpecificItems(tItemParser)
	for k,v in pairs(aSubstances) do
		if string.match(sItemProps, k, 1) then
			sSubstance = k
			break
		end
		if string.match(sItemName, k, 1) then
			sSubstance = k
			break
		end
		for kk,vv in pairs(tItemParser) do
			if string.match(sItemName, kk, 1) then
				sSubstance = vv
				break
			end
		end
	end
	
	return sSubstance
end

--- This function assembles common data needed for processing and passes it to the relevant functions.
--	First, it finds the name and type of the item.
--	Next, it requests the size multiplier (tSizeMult) and substance data (aSubstances) tables from provideValues()
--	Thirdly, it calls checkItemMaterial() to look for substance clues in sItemName
--	After that, it uses the data in sItemType to pas the relevant information to the applicable calculation formula (calcArmorHHP, calcWeaponHHP, or calcItemHHP).
--	Finally, triggers a recalculation of item damage color via its onValueChanged() function in case the ratio has changed.
--	@see provideValues(aSubstances, tSizeMult)
--	@see checkItemMaterial(sItemName, sItemProps, aSubstances)
--	@see calcArmorHHP(sSubstance, aSubstances, tSizeMult, sCharSize)
--	@see calcWeaponHHP(sSubstance, aSubstances, tSizeMult, sCharSize)
--	@see calcItemHHP(sSubstance, aSubstances)
function onValueChanged()
	local sItemName = string.lower(DB.getValue(window.getDatabaseNode(), 'name', ''))
	local sItemType = string.lower(window.type.getValue())

	local sCharSize = string.lower(DB.getValue(window.getDatabaseNode().getChild('...'), 'size', 'medium'))
	local sItemProps = string.lower(window.properties.getValue())
	
	local tSizeMult = {}
	local tSubstances = {}
	provideValues(tSubstances, tSizeMult)

	local sSubstance = checkItemMaterial(sItemName, sItemProps, aSubstances)

	if sItemType == 'armor' then
		calcArmorHHP(sSubstance, tSubstances, tSizeMult, sCharSize)
	elseif sItemType == 'weapon' then
		calcWeaponHHP(sSubstance, tSubstances, tSizeMult, sCharSize)
	else
		calcItemHHP(sSubstance, tSubstances)
	end
	
	window.item_damage.onValueChanged()
end