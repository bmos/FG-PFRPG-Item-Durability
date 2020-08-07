-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

---	This function facilitates conversion to title case.
--	@param first The first character of the string it's processing.
--	@param rest The complete string, except for the first character.
--	@return first:upper()..rest:lower() The re-combined string, converted to title case.
function formatTitleCase(first, rest)
   return first:upper() .. rest:lower()
end

---	This function searches sItemProps, sItemName, and tItemParser for any of the keys in aSubstances.
--	If it ever finds one, it stops searching and returns the key.
--	If none of the materials in tItemParser are a match, it returns an empty string.
--	@param nodeItem The item to be examined.
--	@see provideValues(aSubstances, tSizeMult, tItemParser)
--	@return sSubstance A string containing the material the item is most likely constructed of.
function findSubstance(nodeItem)
	local sSubstance = ''
	
	local sItemName = string.lower(DB.getValue(nodeItem, 'name', ''))
	local sItemProps = string.lower(DB.getValue(nodeItem, 'properties', ''))
	local aSubstances = {}
	local tItemParser = {}
	ItemDurabilityInfo.provideValues(aSubstances, nil, tItemParser)
	
	for k,_ in pairs(aSubstances) do
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