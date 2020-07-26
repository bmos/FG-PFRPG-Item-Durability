-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

function onInit()
	onValueChanged()
end

function onValueChanged()
	local nItemHitpoints = window.hitpoints.getValue()
	if nItemHitpoints and nItemHitpoints >= 1 then
		local nDmg = window.item_damage.getValue()
		local nPercentDmg = nDmg / nItemHitpoints * 100
		if nPercentDmg >= 100 then
			window.item_damage.setColor('FFB22929')
			if DB.getValue(window.getDatabaseNode(), 'carried') == 2 then
				DB.setValue(window.getDatabaseNode(), 'carried', 'number', 1)
			end
			DB.setValue(window.getDatabaseNode(), 'broken', 'number', 2)
			if string.lower(window.type.getValue()) == 'weapon' then
				BrokenPenalties.brokenWeaponPenalties(window.getDatabaseNode(), 2)
			end
			if string.lower(window.type.getValue()) == 'armor' then
				BrokenPenalties.brokenArmorPenalties(window.getDatabaseNode(), 2)
				window.ac.setReadOnly(true)
				window.checkpenalty.setReadOnly(true)
			end
		elseif nPercentDmg >= 50 then
			window.item_damage.setColor('FFEB7B00')
			DB.setValue(window.getDatabaseNode(), 'broken', 'number', 1)
			if string.lower(window.type.getValue()) == 'weapon' then
				BrokenPenalties.brokenWeaponPenalties(window.getDatabaseNode(), 1)
			end
			if string.lower(window.type.getValue()) == 'armor' then
				BrokenPenalties.brokenArmorPenalties(window.getDatabaseNode(), 1)
				window.ac.setReadOnly(true)
				window.checkpenalty.setReadOnly(true)
			end
		else
			window.item_damage.setColor('FF000000')
			DB.setValue(window.getDatabaseNode(), 'broken', 'number', 0)
			if string.lower(window.type.getValue()) == 'weapon' then
				BrokenPenalties.brokenWeaponPenalties(window.getDatabaseNode(), 0)
			end
			if string.lower(window.type.getValue()) == 'armor' then
				BrokenPenalties.brokenArmorPenalties(window.getDatabaseNode(), 0)
				window.ac.setReadOnly(false)
				window.checkpenalty.setReadOnly(false)
			end
		end
	end
end

---	
local function adjustDamage(sDmgTotal, tTypes, bIsRanged)
	local tNone = {'nonlethal','critical'}

	local tPFEnergyHalf = {'fire','cold','acid','lightning','sonic'}

	local t35eEnergyHalf = {'electricity','fire'}
	local t35eEnergyQuarter = {'cold'}

	if bIsRanged then sDmgTotal = sDmgTotal / 2 end

	for _,v in pairs(tTypes) do
		for _, vv in pairs(tNone) do
			if vv == v then
				sDmgTotal = 0
				break
			end
		end
		if DataCommon.isPFRPG() and sDmgTotal then
			for _, vv in pairs(tPFEnergyHalf) do
				if vv == v then
					sDmgTotal = sDmgTotal / 2
					break
				end
			end
		elseif sDmgTotal then
			for _, vv in pairs(t35eEnergyHalf) do
				if vv == v then
					sDmgTotal = sDmgTotal / 2
					break
				end
			end
			for _, vv in pairs(t35eEnergyQuarter) do
				if vv == v then
					sDmgTotal = sDmgTotal / 4
					break
				end
			end
		end
	end

	return math.floor(sDmgTotal)
end

---	
local function findTypedDamage(s, bIsRanged)
	local nFieldStart = 1

	local nTypesEnd = string.find(s, ' ', nFieldStart)
	local sTypes = string.lower(string.sub(s, nFieldStart, nTypesEnd - 1) .. ',')
	local tTypes = {}
	
	local sDmgStart = string.find(s, '%(', nFieldStart)
	local sDmg = string.sub(s, sDmgStart + 1, string.len(s)-1)
	local sDmgTotalStart = string.find(sDmg, '=', nFieldStart)
	local sDmgTotal = string.sub(sDmg, sDmgTotalStart + 1, string.len(s))

	repeat
		local nNextI = string.find(sTypes, ',', nFieldStart)
		table.insert(tTypes, string.sub(sTypes, nFieldStart, nNextI-1))
		nFieldStart = nNextI + 1
	until nFieldStart > string.len(sTypes)
	
	return adjustDamage(sDmgTotal, tTypes, bIsRanged)
end

---	
local function setItemDamage(nDmgTotal)
	local nModifiedDamage = nDmgTotal - window.hardness.getValue()
	if nModifiedDamage > 0 then
		local nDmg = window.item_damage.getValue()
		window.item_damage.setValue(nDmg + nModifiedDamage)
	end
end

---	
local function findTypes(t)
	local nDmgTotal = 0
	local bIsRanged = false
	
	for _,v in ipairs(t) do
		local fieldstart = 1

		local nTypePosition = string.find(v, '%[TYPE: ', fieldstart)
		if string.find(v, '%[DAMAGE %(R%)%]', fieldstart) then bIsRanged = true end
		
		if nTypePosition then
			local nStop = string.len(v)
			local s = string.sub(v, nTypePosition + 7, nStop-1)
			nDmgTotal = nDmgTotal + findTypedDamage(s, bIsRanged)
		end
	end

	setItemDamage(nDmgTotal)
end

---	This function splits a dragged roll description into pieces in a table
local function splitDamageDrop(s)
	local fieldstart = 1
	local fieldend = string.len(s)
	local t = {}
	repeat
		local nexti_s = string.find(s, '%[', fieldstart)
		local nexti_e = string.find(s, '%]', fieldstart)
		table.insert(t, string.sub(s, nexti_s, nexti_e))
		fieldstart = nexti_e + 1
	until fieldstart > string.len(s)
	
	findTypes(t)
end

function onDrop(x, y, draginfo)
	if string.find(draginfo.getDescription(), '%[', 1) then
		splitDamageDrop(draginfo.getDescription())
	end
end