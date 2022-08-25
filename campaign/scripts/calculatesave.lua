--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

--	luacheck: globals onValueChanged getValue getVisible update updateSaves updateSaveVisibility

function updateSaveVisibility()
	local bCL = ((getValue() or 0) > 0);

	window.fortitudesave.setVisible(bCL);
	window.fortitudesave_label.setVisible(bCL);

	window.reflexsave.setVisible(bCL);
	window.reflexsave_label.setVisible(bCL);

	window.willsave.setVisible(bCL);
	window.willsave_label.setVisible(bCL);
end

function updateSaves()
	local nSave = math.floor(0.5 * (getValue() or 0)) + 2;

	window.fortitudesave.setValue(nSave);
	window.reflexsave.setValue(nSave);
	window.willsave.setValue(nSave);
end

function update(...)
	if super and super.update then super.update(...); end

	updateSaveVisibility()
end

function onValueChanged()
	if super and super.onValueChanged then super.onValueChanged(); end

	updateSaves()
	updateSaveVisibility()
end

function onInit()
	if super and super.onInit then super.onInit(); end

	onValueChanged()
end
