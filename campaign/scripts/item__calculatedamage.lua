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
			if window.type.getValue() == 'Weapon' then
				BrokenPenalties.brokenWeaponPenalties(window.getDatabaseNode(), 2)
			end
		elseif nPercentDmg >= 50 then
			window.item_damage.setColor('FFEB7B00')
			DB.setValue(window.getDatabaseNode(), 'broken', 'number', 1)
			if window.type.getValue() == 'Weapon' then
				BrokenPenalties.brokenWeaponPenalties(window.getDatabaseNode(), 1)
			end
		else
			window.item_damage.setColor('FF000000')
			DB.setValue(window.getDatabaseNode(), 'broken', 'number', 0)
			if window.type.getValue() == 'Weapon' then
				BrokenPenalties.brokenWeaponPenalties(window.getDatabaseNode(), 0)
			end
		end
	end
end

---	This function converts CSVs from a string to a table of values
--	@param s input, a string of CSVs
--	@return t output, an indexed table of values
function fromCSV(s)
	local fieldstart = 1

	s = s .. '☹'
	local nTypePosition = string.find(s, '%[TYPE: ', fieldstart) + 7
	local nStop = string.find(s, '☹', fieldstart)
	s = string.sub(s, nTypePosition, nStop) -- trim everything but from 'TYPE: ' to "☹"
	nStop = string.find(s, '%(', fieldstart) - 2
	s = string.sub(s, fieldstart, nStop) -- trim off everything after " ("

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
		if v == 'nonlethal' then
			nDamageDealt = 0
			break
		end
			nDamageDealt = nDamageDealt / 2
		end
		if DataCommon.isPFRPG() then
			for _, vv in pairs(tPFEnergyHalf) do
				if vv == v then
					nDamageDealt = nDamageDealt / 2
					break
				end
			end
		else
			for _, vv in pairs(t35eEnergyHalf) do
				if vv == v then
					nDamageDealt = nDamageDealt / 2
					break
				end
			end
			for _, vv in pairs(t35eEnergyQuarter) do
				if vv == v then
					nDamageDealt = nDamageDealt / 4
					break
				end
			end
		end
	end

	local nModifiedDamage = nDamageDealt - nHardness

	if nModifiedDamage < 1 then
		window.item_damage.setValue(nDmg)
	else
		window.item_damage.setValue(nDmg + nModifiedDamage)
	end
end
