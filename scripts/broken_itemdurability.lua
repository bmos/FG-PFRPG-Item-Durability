--
-- Please see the LICENSE.md file included with this distribution for attribution and copyright information.
--
-- luacheck: globals handleBrokenItem ItemManager.isArmor ItemManager.isShield ItemManager.isWeapon

function handleBrokenItem(nodeItem)
	---	This function checks if the damaged weapon's name matches any in the actions tab and, if so, adds their nodes to tDamagedWeapons.
	--	@param nodeItem A databasenode pointing to the damaged item.
	--	@return tDamagedWeapons A table of databasenodes pointing to the damaged item on the actions tab.
	local function handleWeaponNodeArgs()
		local nodeChar = DB.getChild(nodeItem, '...')
		local sItemName = DB.getValue(nodeItem, 'name', '')
		local sUnbrokenItemName = sItemName:sub(10)

		local tDamagedWeapons = {}
		for _, nodeWeapon in ipairs(DB.getChildList(nodeChar, 'weaponlist')) do
			if sItemName == DB.getValue(nodeWeapon, 'name', '') or sUnbrokenItemName == DB.getValue(nodeWeapon, 'name', '') then
				table.insert(tDamagedWeapons, nodeWeapon)
			end
		end

		return tDamagedWeapons
	end

	local function brokenPenalties(bIsBroken)
		local function brokenWeapon()
			local tDamagedWeapons = handleWeaponNodeArgs()

			if bIsBroken then
				if not ItemManager.isShield(nodeItem) then DB.setValue(nodeItem, 'bonus', 'number', DB.getValue(nodeItem, 'bonusbak', 0) - 2) end
				DB.setValue(nodeItem, 'critical', 'string', 'x2')
				for _, vNode in pairs(tDamagedWeapons) do
					DB.setValue(vNode, 'name', 'string', '[BROKEN] ' .. DB.getValue(vNode, 'name', ''))
					DB.setValue(vNode, 'bonus', 'number', DB.getValue(nodeItem, 'atkbonusbak', 0) - 2)
					DB.setValue(vNode, 'critatkrange', 'number', 20)

					for _, vvNode in ipairs(DB.getChildList(vNode, 'damagelist')) do
						DB.setValue(vvNode, 'bonus', 'number', DB.getValue(nodeItem, 'dmgbonusbak', 0) - 2)
						if DB.getValue(vvNode, 'critmult', 2) > 2 then DB.setValue(vvNode, 'critmult', 'number', 2) end
					end
				end
			else
				if not ItemManager.isShield(nodeItem) then DB.setValue(nodeItem, 'bonus', 'number', DB.getValue(nodeItem, 'bonusbak', 0)) end
				DB.setValue(nodeItem, 'critical', 'string', DB.getValue(nodeItem, 'criticalbak', 'x2'))
				for _, vNode in pairs(tDamagedWeapons) do
					local sItemName = DB.getValue(vNode, 'name', '')
					if sItemName:find('%[BROKEN%]') then DB.setValue(vNode, 'name', 'string', string.gsub(sItemName, '%[BROKEN%]%s', '')) end
					DB.setValue(vNode, 'bonus', 'number', DB.getValue(nodeItem, 'atkbonusbak', 0))
					DB.setValue(vNode, 'critatkrange', 'number', DB.getValue(nodeItem, 'critatkrangebak', 20))
					for _, vvNode in ipairs(DB.getChildList(vNode, 'damagelist')) do
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
					if not nNum then return 0 end
					local nMult = 10 ^ (nDecimalPlaces or 0)
					return math.floor(nNum * nMult + 0.5) / nMult
				end

				local nItemCostSeperator = string.find(sItemCostBak, string.match(sItemCostBak, '[%D]'))
				DB.setValue(
					nodeItem,
					'cost',
					'string',
					round(tonumber(string.sub(sItemCostBak, 1, nItemCostSeperator - 1)) or 0 * 0.75, nil)
						.. ' '
						.. string.sub(sItemCostBak, nItemCostSeperator)
				)
			elseif not bIsBroken then
				DB.setValue(nodeItem, 'cost', 'string', DB.getValue(nodeItem, 'costbak', ''))
			end
		end

		brokenItemCost()
		if ItemManager.isWeapon(nodeItem) then brokenWeapon() end

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

		if ItemManager.isArmor(nodeItem) then brokenArmor() end
		if ItemManager.isShield(nodeItem) and StringManager.contains(Extension.getExtensions(), 'FG-PFRPG-Advanced-Item-Actions') then
			brokenWeapon()
		end
	end

	local function removeBackup()
		for _, nodeName in ipairs({ 'cost', 'bonus', 'ac', 'checkpenalty', 'damage', 'critical', 'atkbonus', 'critatkrange', 'dmgbonus', 'critmult' }) do
			if DB.getValue(nodeItem, nodeName .. 'bak') then DB.deleteChild(nodeItem, nodeName .. 'bak') end
		end
	end

	local function makeBackup()
		DB.setValue(nodeItem, 'costbak', 'string', DB.getValue(nodeItem, 'cost', ''))

		for _, nodeName in ipairs({ 'bonus', 'ac', 'checkpenalty' }) do
			DB.setValue(nodeItem, nodeName .. 'bak', 'number', DB.getValue(nodeItem, nodeName, 0))
		end

		DB.setValue(nodeItem, 'damagebak', 'string', DB.getValue(nodeItem, 'damage', ''))
		DB.setValue(nodeItem, 'criticalbak', 'string', DB.getValue(nodeItem, 'critical', 'x2'))
		local tDamagedWeapons = handleWeaponNodeArgs()
		for _, vNode in pairs(tDamagedWeapons) do
			DB.setValue(nodeItem, 'atkbonusbak', 'number', DB.getValue(vNode, 'bonus', 0))
			DB.setValue(nodeItem, 'critatkrangebak', 'number', DB.getValue(vNode, 'critatkrange', 20))
			for _, vvNode in ipairs(DB.getChildList(vNode, 'damagelist')) do
				DB.setValue(nodeItem, 'dmgbonusbak', 'number', DB.getValue(vvNode, 'bonus', 0))
				DB.setValue(nodeItem, 'critmultbak', 'number', DB.getValue(vvNode, 'critmult', 2))
			end
		end
	end

	local sItemName = DB.getValue(nodeItem, 'name', '')
	if sItemName == '' then return end

	local nBrokenState = DB.getValue(nodeItem, 'broken', 0)
	local messagedata = { sender = DB.getValue(nodeItem, '...name'), font = 'emotefont' }

	if nBrokenState == 2 and not sItemName:find('%[DESTROYED%]') then
		if OptionsManager.isOption('DESTROY_ITEM', 'gone') then
			DB.deleteNode(nodeItem)
		elseif OptionsManager.isOption('DESTROY_ITEM', 'unequipped') then
			DB.setValue(nodeItem, 'carried', 'number', 0)
			DB.setValue(nodeItem, 'name', 'string', '[DESTROYED] ' .. DB.getValue(nodeItem, 'name', ''))
		end

		messagedata.text = string.format(Interface.getString('char_actions_weapon_destroyed'), sItemName)
		Comm.deliverChatMessage(messagedata)
	elseif nBrokenState == 1 and not sItemName:find('%[BROKEN%]') then
		makeBackup()
		brokenPenalties(true)
		DB.setValue(nodeItem, 'name', 'string', '[BROKEN] ' .. DB.getValue(nodeItem, 'name', ''))

		messagedata.text = string.format(Interface.getString('char_actions_weapon_broken'), sItemName)
		Comm.deliverChatMessage(messagedata)
	else
		brokenPenalties(false)
		removeBackup()
		if sItemName:find('%[BROKEN%]') then DB.setValue(nodeItem, 'name', 'string', sItemName:gsub('%[BROKEN%]%s', '')) end
	end
end

local function onBrokenChanged(node) handleBrokenItem(DB.getParent(node)) end

local function getWeaponName(s)
	local sWeaponName = s:gsub('%[ATTACK%s#?%d*%s?%(%u%)%]', '')
	sWeaponName = sWeaponName:gsub('%[%u+%]', '')
	if sWeaponName:match('%[USING%s') then sWeaponName = sWeaponName:match('%[USING%s(.-)%]') end
	sWeaponName = sWeaponName:gsub('%[.+%]', '')
	sWeaponName = sWeaponName:gsub(' %(vs%. .+%)', '')
	sWeaponName = StringManager.trim(sWeaponName)

	return sWeaponName or ''
end

-- examine weapon properties to check if fragile
local function isFragile(nodeWeapon)
	local sWeaponProperties = DB.getValue(nodeWeapon, 'properties', ''):lower()
	local bIsFragile = (sWeaponProperties:find('fragile') or 0) > 0
	local bIsMasterwork = sWeaponProperties:find('masterwork') or false
	local bIsBone = sWeaponProperties:find('bone') or false
	local bIsMagic = DB.getValue(nodeWeapon, 'bonus', 0) > 0
	return (bIsFragile and not bIsMagic and (not bIsMasterwork or bIsBone))
end

local function notifyNoHitpoints(rSource, sWeaponName)
	local messagedata = {
		sender = rSource.sName,
		font = 'emotefont',
		text = string.format(Interface.getString('char_actions_fragile_unknownhp'), sWeaponName),
	}
	Comm.deliverChatMessage(messagedata)
end

--	if weapon is fragile, set as broken or destroyed and post a chat message.
local function breakWeapon(nodeWeapon, sWeaponName, rSource)

	if not nodeWeapon or not isFragile(nodeWeapon) then return end

	local nBroken = DB.getValue(nodeWeapon, 'broken', 0)
	local nItemHitpoints = DB.getValue(nodeWeapon, 'hitpoints', 0)
	local nItemDamage = DB.getValue(nodeWeapon, 'itemdamage', 0)

	if nBroken == 0 then
		DB.setValue(nodeWeapon, 'broken', 'number', 1)
		if nItemHitpoints == 0 then	notifyNoHitpoints(rSource, sWeaponName); return end
		DB.setValue(nodeWeapon, 'itemdamage', 'number', math.floor(nItemHitpoints / 2) + math.max(nItemDamage, 1))
	elseif nBroken == 1 then
		DB.setValue(nodeWeapon, 'broken', 'number', 2)
		if nItemHitpoints == 0 then	notifyNoHitpoints(rSource, sWeaponName); return end
		DB.setValue(nodeWeapon, 'itemdamage', 'number', nItemHitpoints + math.max(nItemDamage, 1))
	end

	local messagedata = {
		sender = rSource.sName,
		font = 'emotefont',
		text = string.format(Interface.getString('char_actions_fragile'), sWeaponName),
	}
	Comm.deliverChatMessage(messagedata)
end

--	luacheck: globals onFumbleBreakWeapon
function onFumbleBreakWeapon(rSource, sDesc)
	if not ActorManager.isPC(rSource) then return end

	local sWeaponName = getWeaponName(sDesc)
	if string.find(sDesc, '%[CONFIRM%]') or sWeaponName == '' then return end

	for _, nodeWeapon in ipairs(DB.getChildList(ActorManager.getCreatureNode(rSource), 'weaponlist')) do
		local sWeaponNameFromNode = getWeaponName(DB.getValue(nodeWeapon, 'name', ''))
		if sWeaponNameFromNode == sWeaponName then
			local _, sWeaponNode = DB.getValue(nodeWeapon, 'shortcut', '')
			breakWeapon(DB.findNode(sWeaponNode), sWeaponName, rSource)
			break
		end
	end
end

-- Function Overrides

local onPostAttackResolve_old
local function onPostAttackResolve_new(rSource, rTarget, rRoll, rMessage, ...)
	onPostAttackResolve_old(rSource, rTarget, rRoll, rMessage, ...)
	if rRoll.sResult == 'fumble' then
		onFumbleBreakWeapon(rSource, rRoll.sDesc)
	end
end

function onInit()
	OptionsManager.registerOption2(
		'DESTROY_ITEM',
		false,
		'option_header_game',
		'opt_lab_item_destroyed',
		'option_entry_cycler',
		{
			labels = 'enc_opt_item_destroyed_gone',
			values = 'gone',
			baselabel = 'enc_opt_item_destroyed_unequipped',
			baseval = 'unequipped',
			default = 'unequipped',
		}
	)

	if Session.IsHost then DB.addHandler(DB.getPath('charsheet.*.inventorylist.*.broken'), 'onUpdate', onBrokenChanged) end

	onPostAttackResolve_old = ActionAttack.onPostAttackResolve
	ActionAttack.onPostAttackResolve = onPostAttackResolve_new
end
