--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals onDrop
function onDrop(_, _, draginfo)
	if string.find(draginfo.getDescription(), '%[DAMAGE', 1) then
		ItemDurabilityDamage.splitDamageTypes(window.getDatabaseNode(), draginfo.getDescription())
	end
end

-- luacheck: globals onValueChanged
function onValueChanged()

	local function setDamageLevel(color, damageLevel)
		window.itemdamage.setColor(color)
		DB.setValue(window.getDatabaseNode(), 'broken', 'number', damageLevel)
	end

	local nItemHitpoints = window.hitpoints.getValue() or 0
	if nItemHitpoints >= 1 then
		local nPercentDmg = window.itemdamage.getValue() / nItemHitpoints * 100
		if nPercentDmg >= 100 then
			setDamageLevel(ColorManager.COLOR_HEALTH_CRIT_WOUNDS, 2)
		elseif nPercentDmg >= 50 then
			setDamageLevel(ColorManager.COLOR_HEALTH_HVY_WOUNDS, 1)
		else
			setDamageLevel(ColorManager.COLOR_FULL, 0)
		end
	else
		setDamageLevel(ColorManager.COLOR_FULL, 0)
	end
end

function onInit() onValueChanged() end
