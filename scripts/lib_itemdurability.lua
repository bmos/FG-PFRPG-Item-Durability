-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

---	This function facilitates conversion to title case.
--	@param first The first character of the string it's processing.
--	@param rest The complete string, except for the first character.
--	@return first:upper()..rest:lower() The re-combined string, converted to title case.
function formatTitleCase(first, rest)
   return first:upper()..rest:lower()
end
