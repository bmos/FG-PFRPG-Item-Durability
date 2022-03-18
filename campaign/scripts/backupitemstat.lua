--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--

function onValueChanged()
  local nodeItem = window.getDatabaseNode()

  local nItemBrokenState = DB.getValue(nodeItem, 'broken')
  local nItemValue = DB.getValue(nodeItem, getName())

  if nItemBrokenState == 0 and string.lower(window.type.getValue()) == 'armor' then
    DB.setValue(nodeItem, getName() .. '.backup', 'number', nItemValue)
  end
end
