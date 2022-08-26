--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

-- luacheck: globals update
function update()
	if super and super.update then super.update(); end

	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = LibraryData.getIDState('item', nodeRecord);

	local sItemSubwindow = type_stats.getValue() -- 'item_main_armor', 'item_main_weapon', or ''

	self.updateControl("hardness", bReadOnly, bID);
	self.updateControl("hitpoints", bReadOnly, bID);
	self.updateControl("itemdamage", bReadOnly, bID);
	self.updateControl("substance", bReadOnly, bID);
	self.updateControl("size", bReadOnly, bID);
	self.updateControl("thickness", bReadOnly, bID);

	if sItemSubwindow == 'item_main_armor' then
		thickness.setVisible(false);
		thickness_label.setVisible(false);
	end

	bHHD = (hardness.getValue() ~= 0) or (hitpoints.getValue() ~= 0) or (itemdamage.getValue() ~= 0);
	item_durability_label.setVisible(bHHD);
	button_rebuildhhp.setVisible(not bReadOnly);
	button_rebuildattributes.setVisible(not bReadOnly);
end