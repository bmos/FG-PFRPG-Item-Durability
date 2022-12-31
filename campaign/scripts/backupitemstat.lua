--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
--	luacheck: globals onValueChanged getName backupValue

function backupValue()
	local nodeItem = window.getDatabaseNode()

	local nItemBrokenState = DB.getValue(nodeItem, 'broken')
	local nItemValue = DB.getValue(nodeItem, getName())

	if nItemBrokenState == 0 and string.lower(DB.getValue(nodeItem, 'type', '')) == 'armor' then
		DB.setValue(nodeItem, getName() .. '.backup', 'number', nItemValue)
	end
end

function onInit()
	if super and super.onInit then super.onInit() end

	onValueChanged()
end

function onValueChanged()
	if super and super.onValueChanged then super.onValueChanged() end

	backupValue()
end
