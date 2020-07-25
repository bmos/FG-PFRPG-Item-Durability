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
			window.item_damage.setColor('800D0D0D')
		elseif nPercentDmg >= 66 then
			window.item_damage.setColor('FFB22929')
		elseif nPercentDmg >= 33 then
			window.item_damage.setColor('FFEB7B00')
		else
			window.item_damage.setColor('FF000000')
		end
	end
end

---	This function converts CSVs from a string to a table of values
--	@param s input, a string of CSVs
--	@return t output, an indexed table of values
function fromCSV(s)
	local fieldstart = 1

	s = s .. '☹'
	local nTypePosition = string.find(s, 'TYPE: ', fieldstart) + 6
	local nStop = string.find(s, '☹', fieldstart)
	s = string.sub(s, nTypePosition, nStop) -- trim off everything to "TYPE: "
	nStop = string.find(s, '%(', fieldstart) - 2
	s = string.sub(s, fieldstart, nStop) -- trim off everything to " ("

	s = string.lower(s .. ',')        -- ending comma
	local t = {}        -- table to collect fields
	repeat
		local nexti = string.find(s, ',', fieldstart)
		table.insert(t, string.sub(s, fieldstart, nexti-1))
		fieldstart = nexti + 1
	until fieldstart > string.len(s)

	return t
end

function onDrop(x, y, draginfo)
	local nDmg = window.item_damage.getValue()
	local nHardness = window.hardness.getValue()
	local nDamageDealt = draginfo.getNumberData()
	
	local tPFEnergyHalf = {'fire','cold','acid','lightning','sonic'}
	local t35eEnergyHalf = {'electricity','fire'}
	local t35eEnergyQuarter = {'cold'}
	local tDmgType = fromCSV(draginfo.getDescription())

	for _,v in pairs(tDmgType) do
		if DataCommon.isPFRPG() then
			for _, vv in pairs(tPFEnergyHalf) do
				if v == vv then
					nDamageDealt = nDamageDealt / 2
					break
				end
			end
		else
			for _, vv in pairs(t35eEnergyHalf) do
				if v == vv then
					nDamageDealt = nDamageDealt / 2
					break
				end
			end
			for _, vv in pairs(t35eEnergyQuarter) do
				if v == vv then
					nDamageDealt = nDamageDealt / 4
					break
				end
			end
		end
	end

	Debug.chat(tDmgType, nDamageDealt)

	local nModifiedDamage = nDamageDealt - nHardness

	if nModifiedDamage < 1 then
		window.item_damage.setValue(nDmg)
	else
		window.item_damage.setValue(nDmg + nModifiedDamage)
	end
end
