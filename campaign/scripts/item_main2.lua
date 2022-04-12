--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
--	luacheck: globals updateControl
function updateControl(sControl, bReadOnly, bID)
	if not self[sControl] then return false; end

	if not bID then return self[sControl].update(bReadOnly, true); end

	return self[sControl].update(bReadOnly);
end

-- luacheck: globals getItemType
function getItemType()
	local bWeapon, bArmor, bShield, bWand, bStaff, bWondrous;
	--	luacheck: globals type
	local sType = string.lower(type.getValue());
	local sSubtype = string.lower(subtype.getValue());

	if sType:match('weapon') then bWeapon = true; end
	if sType:match('armor') then bArmor = true; end
	if sType:match('wand') then bWand = true; end
	if sType:match('staff') then bStaff = true; end
	if sType:match('wondrous item') then bWondrous = true; end
	if sType:match('shield') or sSubtype:match('shield') then bShield = true; end

	return bWeapon, bArmor, bShield, bWand, bStaff, bWondrous;
end

-- luacheck: globals update
function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID, bOptionID = LibraryData.getIDState('item', nodeRecord);

	local bWeapon, bArmor, _, bWand, bStaff, bWondrous = getItemType();

	local bSection1 = false;
	if Session.IsHost then
		if updateControl('nonid_name', bReadOnly, true) then bSection1 = true; end
	else
		updateControl('nonid_name', false);
	end
	if (Session.IsHost or not bID) then
		if updateControl('nonidentified', bReadOnly, true) then bSection1 = true; end
	else
		updateControl('nonidentified', false);
	end

	local bSection2 = false;
	if updateControl('type', bReadOnly, bID) then bSection2 = true; end
	if updateControl('subtype', bReadOnly, bID) then bSection2 = true; end

	local bSection3 = false;
	if updateControl('cost', bReadOnly, bID) then bSection3 = true; end
	if updateControl('weight', bReadOnly, bID) then bSection3 = true; end

	local bSection3a = false; -- Item Durability
	if updateControl('hardness', bReadOnly, bID) then bSection3a = true; end
	if updateControl('hitpoints', bReadOnly, bID) then bSection3a = true; end
	if updateControl('itemdamage', bReadOnly, bID) then bSection3a = true; end
	item_durability_label.setVisible(bSection3a); -- all-or-nothing hide/show of section
	hardness.setVisible(bSection3a);
	hardness_label.setVisible(bSection3a);
	hitpoints.setVisible(bSection3a);
	hitpoints_label.setVisible(bSection3a);
	itemdamage.setVisible(bSection3a);
	itemdamage_label.setVisible(bSection3a);
	itemdamage.setReadOnly(false);
	button_rebuildhhp.setVisible(bSection3a);

	local bSection3b = false; -- Item Durability
	if updateControl('size', bReadOnly, bID) then bSection3b = true; end
	if updateControl('substance', bReadOnly, bID) then bSection3b = true; end
	if updateControl('thickness', bReadOnly, bID and not bArmor) then bSection3b = true; end
	button_rebuildattributes.setVisible(bSection3b); -- all-or-nothing hide/show of section
	if size then
		size.setVisible(bSection3b);
		size_label.setVisible(bSection3b)
	end
	substance.setVisible(bSection3b);
	substance_label.setVisible(bSection3b);
	thickness.setVisible(bSection3b and not bArmor);
	thickness_label.setVisible(bSection3b and not bArmor);

	local bSection4 = false;
	if updateControl('damage', bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl('damagetype', bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl('critical', bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl('range', bReadOnly, bID and bWeapon) then bSection4 = true; end

	if updateControl('ac', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('maxstatbonus', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('checkpenalty', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('spellfailure', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('speed30', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('speed20', bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl('properties', bReadOnly, bID) then bSection4 = true; end

	local bSection5 = false
	if updateControl('bonus', bReadOnly, bID and (bWeapon or bArmor)) then bSection5 = true; end
	if updateControl('aura', bReadOnly, bID) then bSection5 = true; end
	if updateControl('prerequisites', bReadOnly, bID) then bSection5 = true; end
	local bCL = updateControl('cl', bReadOnly, bID);
	if bCL then bSection5 = true; end
	fortitudesave.setVisible(bCL);
	fortitudesave_label.setVisible(bCL);
	reflexsave.setVisible(bCL);
	reflexsave_label.setVisible(bCL);
	willsave.setVisible(bCL);
	willsave_label.setVisible(bCL);
	item_saves_label.setVisible(bCL);

	local bSection6 = bID;
	description.setVisible(bID);
	description.setReadOnly(bReadOnly);

	--	This is compatibility for 'Enhanced Items' by Llisandur
	local bPFRPGEILoaded = StringManager.contains(Extension.getExtensions(), 'FG-PFRPG-Enhanced-Items');
	local bSection7 = false;
	if bPFRPGEILoaded then
		updateControl('sourcebook', bReadOnly, bID);
		gmonly_label.setVisible(false);
		gmonly.setVisible(false);
		if bOptionID and Session.IsHost then
			if updateControl('gmonly', bReadOnly, true) then bSection7 = true; end
		elseif Session.IsHost then
			updateControl('gmonly', bReadOnly, false);
		end
	end
	--	End compatibility patch

	--	This is compatibility for 'Enhanced Items' by Llisandur
	if bPFRPGEILoaded then
		if updateControl('charge', bReadOnly, bID and (bWand or bStaff)) then
			bSection4 = true;
			maxcharges.setReadOnly(bReadOnly);
			charge.setReadOnly(false);
			current_label.setVisible(true);
			maxcharges.setVisible(true);
			maxcharges_label.setVisible(true);
		else
			current_label.setVisible(false);
			maxcharges.setVisible(false);
			maxcharges_label.setVisible(false);
		end

		if updateControl('equipslot', bReadOnly, bID and bWondrous) then bSection4 = true; end
	end
	--	End compatibility patch

	divider.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection3a);
	divider3a.setVisible((bSection1 or bSection2 or bSection3 or bSection3a) and bSection3b);
	divider3b.setVisible((bSection1 or bSection2 or bSection3 or bSection3a or bSection3b) and bSection4);
	divider4.setVisible((bSection1 or bSection2 or bSection3 or bSection3a or bSection3b or bSection4) and bSection5);
	divider5.setVisible((bSection1 or bSection2 or bSection3 or bSection3a or bSection3b or bSection4 or bSection5) and bSection6);
	if bPFRPGEILoaded and Session.IsHost then
		divider6.setVisible((bSection1 or bSection2 or bSection3 or bSection3a or bSection3b or bSection4 or bSection5 or bSection6) and bSection7);
	end
end

--	luacheck: globals VisDataCleared
function VisDataCleared() update(); end

--	luacheck: globals InvisDataAdded
function InvisDataAdded() update(); end

function onInit() update(); end
