--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

--	luacheck: globals onValueChanged setValue setVisible
function onValueChanged(nCL)
	if super and super.onValueChanged then super.onValueChanged(); end
	if not nCL then nCL = 0; end
	setValue(math.floor(0.5 * nCL) + 2)
	setVisible(nCL > 0)
end
