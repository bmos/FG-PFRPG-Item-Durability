-- 
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

function onInit()
	update()
	substance.onValueChanged()
end

function VisDataCleared()
	update()
end

function InvisDataAdded()
	update()
end

function updateControl(sControl, bReadOnly, bID)
	if not self[sControl] then
		return false
	end
		
	if not bID then
		return self[sControl].update(bReadOnly, true)
	end
	
	return self[sControl].update(bReadOnly)
end

function update()
	local nodeRecord = getDatabaseNode()
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord)
	local bID, bOptionID = ItemManager.getIDState(nodeRecord)

	local sType = string.lower(type.getValue())
	
--	This is compatibility for "Enhanced Items" by Llisandur

	local bWeapon = (sType == 'weapon')
	local bArmor = (sType == 'armor')
	local bWand
	local bStaff
	local bWondrous

	local bPFRPGEILoaded = StringManager.contains(Extension.getExtensions(), "PFRPG - Enhanced Items")
	if bPFRPGEILoaded then
		if sType:match("weapon") then
			bWeapon = true
		else
			bWeapon = false
		end
		if sType:match("armor") then
			bArmor = true
		else
			bArmor = false
		end
		if sType:match("wand") then
			bWand = true
		else
			bWand = false
		end
		if sType:match("staff") then
			bStaff = true
		else
			bStaff = false
		end
		if sType:match("wondrous item") then
			bWondrous = true
		else
			bWondrous = false
		end
	end
	
	local bSection1 = false
	if bOptionID and User.isHost() then
		if updateControl('nonid_name', bReadOnly, true) then bSection1 = true; end
	else
		updateControl('nonid_name', false)
	end
	if bOptionID and (User.isHost() or not bID) then
		if updateControl('nonidentified', bReadOnly, true) then bSection1 = true; end
	else
		updateControl('nonidentified', false)
	end

	local bSection2 = false
	if updateControl('type', bReadOnly, bID) then bSection2 = true; end
	if updateControl('subtype', bReadOnly, bID) then bSection2 = true; end
	
	local bSection2a = false
	if updateControl('hardness', bReadOnly, bID) then bSection2a = true; end
	if updateControl('hitpoints', bReadOnly, bID) then bSection2a = true; end
	if updateControl('item_damage', bReadOnly, bID) then bSection2a = true; end
	if updateControl('hitpoints', bReadOnly, bID) then item_damage.setVisible(true); item_damage_label.setVisible(true) end
	item_damage.setReadOnly(false)
	
	local bSection2b = false
	if updateControl('substance', bReadOnly, bID) then bSection2b = true; end
	if bArmor then thickness.setVisible(false); thickness_label.setVisible(false) elseif
		updateControl('thickness', bReadOnly, bID) then thickness.setVisible(true); thickness_label.setVisible(true); bSection2b = true; end
	if updateControl('size', bReadOnly, bID) then bSection2b = true; end
	
	local bSection3 = false
	if updateControl('cost', bReadOnly, bID) then bSection3 = true; end
	if updateControl('weight', bReadOnly, bID) then bSection3 = true; end

--	This is compatibility for "Advanced Character Inventory Manager" by rmilmine
	local bSection8 = false
	if StringManager.contains(Extension.getExtensions(), "Advanced Character Inventory Manager for 3.5E and Pathfinder") then
		if updateControl("damage", bReadOnly, bID and (bWeapon or bShield)) then bSection8 = true; end
		if updateControl("damagetype", bReadOnly, bID and (bWeapon or bShield)) then bSection8 = true; end
		if updateControl("critical", bReadOnly, bID and (bWeapon or bShield)) then bSection8 = true; end
		if updateControl("range", bReadOnly, bID and (bWeapon or bShield)) then bSection8 = true; end
	end
--	End compatibility patch

	local bSection4 = false
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

--	This is compatibility for "Enhanced Items" by Llisandur
	if bPFRPGEILoaded then
		current_label.setVisible(false)
		maxcharges.setVisible(false)
		maxcharges_label.setVisible(false)
		if updateControl("charge", bReadOnly, bID and (bWand or bStaff)) then
			current_label.setVisible(true)
			maxcharges.setVisible(true)
			maxcharges.setReadOnly(bReadOnly)
			maxcharges_label.setVisible(true)
			bSection8 = true
		end
		charge.setReadOnly(false)

		if updateControl("equipslot", bReadOnly, bID and bWondrous) then bSection8 = true; end
	end
--	End compatibility patch

	if updateControl('properties', bReadOnly, bID and (bWeapon or bArmor)) then bSection4 = true; end
	
	local bSection5 = false
	if updateControl('bonus', bReadOnly, bID and (bWeapon or bArmor)) then bSection5 = true; end
	if updateControl('aura', bReadOnly, bID) then bSection5 = true; end
	if updateControl('cl', bReadOnly, bID) then bSection5 = true; end
	if updateControl('prerequisites', bReadOnly, bID) then bSection5 = true; end
	
	local bSection6 = bID
	description.setVisible(bID)
	description.setReadOnly(bReadOnly)

--	This is compatibility for "Enhanced Items" by Llisandur
	local bSection7 = false
	if bPFRPGEILoaded then
		updateControl("sourcebook", bReadOnly, bID)
		divider6.setVisible(false)
		gmonly_label.setVisible(false)
		gmonly.setVisible(false)
		if bOptionID and User.isHost() then
			if updateControl("gmonly", bReadOnly, true) then bSection7 = true; end
		else
			updateControl("gmonly", bReadOnly, false)
		end
		if User.isHost() then 
			divider6.setVisible((bSection1 or bSection2 or bSection3 or bSection4 or bSection5) and bSection7)
		end
	end
--	End compatibility patch

	divider.setVisible(bSection1 and bSection2)
	divider2.setVisible((bSection1 or bSection2) and bSection2a)
	divider2a.setVisible((bSection2a) and bSection2b) -- hides divider for hhp if 2a and 2b are true
	divider2b.setVisible((bSection2b) and bSection3) -- hides divider for substance,thickness,size if 2b and 3 are true
	if StringManager.contains(Extension.getExtensions(), "Advanced Character Inventory Manager for 3.5E and Pathfinder") then
		divider3.setVisible((bSection1 or bSection2 or bSection2a or bSection2b or bSection3) and bSection4)
		divider8.setVisible((bSection1 or bSection2 or bSection2a or bSection2b or bSection3 or bSection8) and bSection4) else
		divider3.setVisible((bSection1 or bSection2 or bSection2a or bSection2b or bSection3) and bSection4)
	end
	divider4.setVisible((bSection1 or bSection2 or bSection2a or bSection3 or bSection4) and bSection5)
	divider5.setVisible((bSection1 or bSection2 or bSection2a or bSection3 or bSection4 or bSection5) and bSection6)
end
