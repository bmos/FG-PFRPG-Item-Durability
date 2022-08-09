--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: globals handleBrokenItem
function handleBrokenItem(nodeItem)

	---	This function checks if the damaged weapon's name matches any in the actions tab and, if so, adds their nodes to tDamagedWeapons.
	--	@param nodeItem A databasenode pointing to the damaged item.
	--	@return tDamagedWeapons A table of databasenodes pointing to the damaged item on the actions tab.
	local function handleWeaponNodeArgs()
		local nodeChar = nodeItem.getChild('...')
		local sItemName = DB.getValue(nodeItem, 'name', '')
		local sUnbrokenItemName = sItemName:sub(10)

		local tDamagedWeapons = {}
		for _, nodeWeapon in pairs(DB.getChildren(nodeChar, 'weaponlist')) do
			if sItemName == DB.getValue(nodeWeapon, 'name', '') or sUnbrokenItemName == DB.getValue(nodeWeapon, 'name', '') then
				table.insert(tDamagedWeapons, nodeWeapon)
			end
		end

		return tDamagedWeapons
	end

	local function brokenPenalties(bIsBroken)

		local function brokenWeapon(sItemSubtype)
			local tDamagedWeapons = handleWeaponNodeArgs()

			if bIsBroken then
				if not sItemSubtype:match('shield') then DB.setValue(nodeItem, 'bonus', 'number', DB.getValue(nodeItem, 'bonusbak', 0) - 2) end
				DB.setValue(nodeItem, 'critical', 'string', 'x2')
				for _, vNode in pairs(tDamagedWeapons) do
					DB.setValue(vNode, 'name', 'string', '[BROKEN] ' .. DB.getValue(vNode, 'name', ''))
					DB.setValue(vNode, 'bonus', 'number', DB.getValue(nodeItem, 'atkbonusbak', 0) - 2)
					DB.setValue(vNode, 'critatkrange', 'number', 20)

					for _, vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
						DB.setValue(vvNode, 'bonus', 'number', DB.getValue(nodeItem, 'dmgbonusbak', 0) - 2)
						if DB.getValue(vvNode, 'critmult', 2) > 2 then DB.setValue(vvNode, 'critmult', 'number', 2) end
					end
				end
			else
				if not sItemSubtype:match('shield') then DB.setValue(nodeItem, 'bonus', 'number', DB.getValue(nodeItem, 'bonusbak', 0)) end
				DB.setValue(nodeItem, 'critical', 'string', DB.getValue(nodeItem, 'criticalbak', 'x2'))
				for _, vNode in pairs(tDamagedWeapons) do
					local sItemName = DB.getValue(vNode, 'name', '')
					if sItemName:find('%[BROKEN%]') then DB.setValue(vNode, 'name', 'string', sItemName:sub(10)) end
					DB.setValue(vNode, 'bonus', 'number', DB.getValue(nodeItem, 'atkbonusbak', 0))
					DB.setValue(vNode, 'critatkrange', 'number', DB.getValue(nodeItem, 'critatkrangebak', 20))
					for _, vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
						DB.setValue(vvNode, 'bonus', 'number', DB.getValue(nodeItem, 'dmgbonusbak', 0))
						if DB.getValue(vvNode, 'critmultbak', 2) > 2 then
							DB.setValue(vvNode, 'critmult', 'number', DB.getValue(nodeItem, 'critmultbak', 2))
						end
					end
				end
			end
		end

		local function brokenItemCost()
			local sItemCostBak = DB.getValue(nodeItem, 'costbak', ''):gsub(',+', ''):gsub('%s+', '')

			if bIsBroken and sItemCostBak ~= '' then

				---	This function rounds nNum to nDecimalPlaces (or to a whole number)
				local function round(nNum, nDecimalPlaces)
					if not nNum then return 0; end
					local nMult = 10 ^ (nDecimalPlaces or 0)
					return math.floor(nNum * nMult + 0.5) / nMult
				end

				local nItemCostSeperator = string.find(sItemCostBak, string.match(sItemCostBak, '[%D]'))
				DB.setValue(
								nodeItem, 'cost', 'string', round(tonumber(string.sub(sItemCostBak, 1, nItemCostSeperator - 1)) or 0 * .75, nil) .. ' ' ..
												string.sub(sItemCostBak, nItemCostSeperator)
				)
			elseif not bIsBroken then
				DB.setValue(nodeItem, 'cost', 'string', DB.getValue(nodeItem, 'costbak', ''))
			end
		end

		brokenItemCost()
		local sItemType = string.lower(DB.getValue(nodeItem, 'type', ''))
		local sItemSubtype = string.lower(DB.getValue(nodeItem, 'subtype', ''))
		if sItemType:match('weapon') then brokenWeapon(sItemSubtype) end

		local function brokenArmor()
			for _, nodeName in ipairs({ 'bonus', 'ac', 'checkpenalty' }) do
				local value
				if bIsBroken then
					value = math.floor(DB.getValue(nodeItem, nodeName .. 'bak', 0) / 2)
				else
					value = DB.getValue(nodeItem, nodeName .. 'bak', 0)
				end
				DB.setValue(nodeItem, nodeName, 'number', value)
			end
		end

		if sItemType:match('armor') then brokenArmor() end
		if sItemSubtype:match('shield') and StringManager.contains(Extension.getExtensions(), 'FG-PFRPG-Advanced-Item-Actions') then
			brokenWeapon(sItemSubtype)
		end
	end

	local function removeBackup()
		for _, nodeName in ipairs(
						                   { 'cost', 'bonus', 'ac', 'checkpenalty', 'damage', 'critical', 'atkbonus', 'critatkrange', 'dmgbonus', 'critmult' }
		                   ) do if DB.getValue(nodeItem, nodeName .. 'bak') then nodeItem.getChild(nodeName .. 'bak').delete() end end
	end

	local function makeBackup()
		DB.setValue(nodeItem, 'costbak', 'string', DB.getValue(nodeItem, 'cost', ''));

		for _, nodeName in ipairs({ 'bonus', 'ac', 'checkpenalty' }) do
			DB.setValue(nodeItem, nodeName .. 'bak', 'number', DB.getValue(nodeItem, nodeName, 0));
		end

		DB.setValue(nodeItem, 'damagebak', 'string', DB.getValue(nodeItem, 'damage', ''));
		DB.setValue(nodeItem, 'criticalbak', 'string', DB.getValue(nodeItem, 'critical', 'x2'));
		local tDamagedWeapons = handleWeaponNodeArgs();
		for _, vNode in pairs(tDamagedWeapons) do
			DB.setValue(nodeItem, 'atkbonusbak', 'number', DB.getValue(vNode, 'bonus', 0));
			DB.setValue(nodeItem, 'critatkrangebak', 'number', DB.getValue(vNode, 'critatkrange', 20));
			for _, vvNode in pairs(DB.getChildren(vNode, 'damagelist')) do
				DB.setValue(nodeItem, 'dmgbonusbak', 'number', DB.getValue(vvNode, 'bonus', 0));
				DB.setValue(nodeItem, 'critmultbak', 'number', DB.getValue(vvNode, 'critmult', 2));
			end
		end
	end

	local sItemName = DB.getValue(nodeItem, 'name', '');
	if sItemName ~= '' then
		local nBrokenState = DB.getValue(nodeItem, 'broken', 0);
		local rActor = ActorManager.resolveActor(nodeItem.getChild('...'));
		local messagedata = { text = '', sender = rActor.sName, font = "emotefont" }

		if nBrokenState == 2 and not sItemName:find('%[DESTROYED%]') then
			if OptionsManager.isOption('DESTROY_ITEM', 'gone') then
				nodeItem.delete();
			elseif OptionsManager.isOption('DESTROY_ITEM', 'unequipped') then
				DB.setValue(nodeItem, 'carried', 'number', 0);
				DB.setValue(nodeItem, 'name', 'string', '[DESTROYED] ' .. DB.getValue(nodeItem, 'name', ''));
			end

			messagedata.text = string.format(Interface.getString('char_actions_weapon_destroyed'), sItemName)
			Comm.deliverChatMessage(messagedata)
		elseif nBrokenState == 1 and not sItemName:find('%[BROKEN%]') then
			makeBackup();
			brokenPenalties(true);
			DB.setValue(nodeItem, 'name', 'string', '[BROKEN] ' .. DB.getValue(nodeItem, 'name', ''));

			messagedata.text = string.format(Interface.getString('char_actions_weapon_broken'), sItemName)
			Comm.deliverChatMessage(messagedata)
		else
			brokenPenalties(false);
			removeBackup();
			if sItemName:find('%[BROKEN%]') then DB.setValue(nodeItem, 'name', 'string', sItemName:sub(10)) end
		end
	end
end

local function onBrokenChanged(node) handleBrokenItem(node.getParent()) end

function onInit()
	if Session.IsHost then DB.addHandler(DB.getPath('charsheet.*.inventorylist.*.broken'), 'onUpdate', onBrokenChanged) end

	OptionsManager.registerOption2(
					'DESTROY_ITEM', false, 'option_header_game', 'opt_lab_item_destroyed', 'option_entry_cycler', {
						labels = 'enc_opt_item_destroyed_gone',
						values = 'gone',
						baselabel = 'enc_opt_item_destroyed_unequipped',
						baseval = 'unequipped',
						default = 'unequipped',
					}
	)
end
