--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals update HHDVisibility

function HHDVisibility(bReadOnly)
	local bHHD = not bReadOnly
	bHHD = bHHD or (hardness.getValue() ~= 0) or (hitpoints.getValue() ~= 0) or (itemdamage.getValue() ~= 0)

	item_durability_label.setVisible(bHHD)

	hardness.setVisible(bHHD)
	hardness.setReadOnly(bReadOnly)
	hardness_label.setVisible(bHHD)

	hitpoints.setVisible(bHHD)
	hitpoints.setReadOnly(bReadOnly)
	hitpoints_label.setVisible(bHHD)

	itemdamage.setVisible(bHHD)
	itemdamage_label.setVisible(bHHD)
end

function update()
	if super and super.update then super.update() end

	local nodeRecord = getDatabaseNode()
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord)
	local bID = LibraryData.getIDState('item', nodeRecord)

	local sItemSubwindow = type_stats.getValue() -- 'item_main_armor', 'item_main_weapon', or ''

	WindowManager.callSafeControlUpdate(self, 'substance', bReadOnly, not bID)
	WindowManager.callSafeControlUpdate(self, 'size', bReadOnly)
	WindowManager.callSafeControlUpdate(self, 'thickness', bReadOnly)

	if sItemSubwindow == 'item_main_armor' then
		thickness.setVisible(false)
		thickness_label.setVisible(false)
	end

	HHDVisibility(bReadOnly)
	button_rebuildhhp.setVisible(not bReadOnly)
	button_rebuildattributes.setVisible(not bReadOnly)
end
