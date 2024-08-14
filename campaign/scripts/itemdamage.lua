--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals onDrop onValueChanged setDamageLevel checkDamageLevel update

function onDrop(_, _, draginfo)
	if string.find(draginfo.getDescription(), "%[DAMAGE", 1) then
		ItemDurabilityDamage.splitDamageTypes(window.getDatabaseNode(), draginfo.getDescription())
	end
end

function setDamageLevel(color, damageLevel)
	window.itemdamage.setColor(color)
	DB.setValue(window.getDatabaseNode(), "broken", "number", damageLevel)
end

function checkDamageLevel()
	local nItemHitpoints = window.hitpoints.getValue() or 0
	if nItemHitpoints == 0 then
		return
	end

	if nItemHitpoints >= 1 then
		local nPercentDmg = window.itemdamage.getValue() / nItemHitpoints * 100
		if nPercentDmg >= 100 then
			setDamageLevel(ColorManager.getUIColor("health_wounds_critical"), 2)
			return
		elseif nPercentDmg >= 50 then
			setDamageLevel(ColorManager.getUIColor("health_wounds_heavy"), 1)
			return
		end
	end

	setDamageLevel(ColorManager.getUIColor("usage_full"), 0)
end

function onValueChanged()
	if super and super.onValueChanged then
		super.onValueChanged()
	end

	checkDamageLevel()
end

function onInit()
	if super and super.onInit then
		super.onInit()
	end

	onValueChanged()
end
