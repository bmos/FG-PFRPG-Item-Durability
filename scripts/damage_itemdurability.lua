-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

---	This function adjusts the damage total based on a number of factors.
--	Depending on the ruleset and damage type, the damage could be full, half, quarter, or none.
--	After processing, the total is rounded down.
--	Finally, it is returned to the calling function.
local function adjustDamageTypes(nDmgTotal, tTypes, bIsRanged)
	local tNone = {'nonlethal','critical','positive','negative'}
	
	local tPFEnergyHalf = {'fire','cold','acid','lightning','sonic'}
	
	local t35eEnergyHalf = {'electricity','fire'}
	local t35eEnergyQuarter = {'cold'}
	
	if bIsRanged then nDmgTotal = nDmgTotal / 2 end
	
	for _,v in pairs(tTypes) do
		v = string.gsub(v, "%s+", "")
		for _, vv in pairs(tNone) do
			if vv == v then
				nDmgTotal = 0
				break
			end
		end
		if DataCommon.isPFRPG() and nDmgTotal then
			for _, vv in pairs(tPFEnergyHalf) do
				if vv == v then
					nDmgTotal = nDmgTotal / 2
					break
				end
			end
		elseif nDmgTotal then
			for _, vv in pairs(t35eEnergyHalf) do
				if vv == v then
					nDmgTotal = nDmgTotal / 2
					break
				end
			end
			for _, vv in pairs(t35eEnergyQuarter) do
				if vv == v then
					nDmgTotal = nDmgTotal / 4
					break
				end
			end
		end
	end
	
	return math.floor(nDmgTotal) or 0
end

---	This function extracts damage amounts and types from sDamage.
--	These are then processed through adjustDamageTypes() along with bIsRanged.
--	The adjusted damage total returned from adjustDamageTypes() is then returned to the calling function.
--	@see adjustDamageTypes(sDmg, tTypes, bIsRanged)
local function findTypedDamage(sDamage, bIsRanged)
	local nFieldStart = 1
	
	local sDmgStart = string.find(sDamage, '%(', nFieldStart)
	local sDmg = string.sub(sDamage, sDmgStart + 1, string.len(sDamage) - 1)
	local nDmgTotalStart = string.find(sDmg, '=', nFieldStart)
	if nDmgTotalStart then sDmg = string.sub(sDmg, nDmgTotalStart + 1, string.len(sDamage)) end
	
	local sTypes = string.lower(string.sub(sDamage, nFieldStart, sDmgStart - 2) .. ',')
	local tTypes = {}
	
	repeat
		local nNextI = string.find(sTypes, ',', nFieldStart)
		table.insert(tTypes, string.sub(sTypes, nFieldStart, nNextI-1))
		nFieldStart = nNextI + 1
	until nFieldStart > string.len(sTypes)
	
	return adjustDamageTypes(tonumber(sDmg), tTypes, bIsRanged)
end

---	This function 
local function setItemDamage(nodeItem, nDmgTotal, nBypassThresh)
	local nHardness = DB.getValue(nodeItem, 'hardness')
	if nBypassThresh then
		if nBypassThresh > nHardness then nHardness = 0 end
	end

	local nModifiedDamage = nDmgTotal - nHardness
	if nModifiedDamage > 0 then
		local nPreviousDmg = DB.getValue(nodeItem, 'itemdamage')
		DB.setValue(nodeItem, 'itemdamage', 'number', nPreviousDmg + nModifiedDamage)
	end
end

---	This function sends each damage entry in tDamageTypes to findTypedDamage().
--	The returned number is totaled with any other typed damage (for weapons that do damage of multiple types).
--	The total is then sent along with nBypassThresh to setItemDamage()
--	@see findTypedDamage(sDamage, bIsRanged)
--	@see setItemDamage(nodeItem, nDmgTotal, nBypassThresh)
local function sumTypes(nodeItem, tDamageTypes, nBypassThresh)
	local nDmgTotal = 0
	local bIsRanged = false
	
	for _,v in ipairs(tDamageTypes) do
		local nFieldStart = 1
		
		if string.find(v, '%[DAMAGE %(R%)%]', nFieldStart) then bIsRanged = true end
		
		local nTypePosition = string.find(v, '%[TYPE: ', nFieldStart)
		if nTypePosition then
			local nFieldStop = string.len(v)
			local sDamage = string.sub(v, nTypePosition + 7, nFieldStop - 1) -- format is "slashing (1d4+5=4)"
			nDmgTotal = nDmgTotal + findTypedDamage(sDamage, bIsRanged)
		end
	end
	
	setItemDamage(nodeItem, nDmgTotal, nBypassThresh)
end

---	This function splits up a dragged damage roll description.
--	The resulting table is supplied to sumTypes().
--	If the damage type is adamantine, it also passes a damage bypass threshold of 20.
--	@see sumTypes(nodeItem, tDamageTypes, nBypassThresh)
function splitDamageTypes(nodeItem, sDragInfo)
	local nFieldStart = 1
	local fieldend = string.len(sDragInfo)
	local tDamageTypes = {}
	repeat
		local nexti_s = string.find(sDragInfo, '%[', nFieldStart)
		local nexti_e = string.find(sDragInfo, '%]', nFieldStart)
		table.insert(tDamageTypes, string.sub(sDragInfo, nexti_s, nexti_e))
		nFieldStart = nexti_e + 1
	until nFieldStart > string.len(sDragInfo)
	
	local nBypassThresh = nil
	if string.find(string.lower(sDragInfo), 'adamantine', 1) then nBypassThresh = 20 end
	sumTypes(nodeItem, tDamageTypes, nBypassThresh)
end