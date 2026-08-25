local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onThink() npcHandler:onThink() end
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid)
	if focus == cid then
		selfSay('Good fechar sir!')
		doSendDialogNpc(cid, getNpcId(), "Good fechar sir!", "fechar")
		focus = 0
		talk_start = 0
		npcHandler:unGreet(cid)
	end
end
function onCreatureTurn(creature) end

local function msgcontains(txt, str)
	return (string.find(txt, str) and not string.find(txt, '(%w+)' .. str) and not string.find(txt, str .. '(%w+)'))
end

local function getPokeballsInContainerHeal(container)
	if not isContainer(container) then return {} end
	local items = {}
	for slot = 0, getContainerSize(container) - 1 do
		local item = getContainerItem(container, slot)
		if isPokeball(item.itemid) then
			table.insert(items, item.uid)
		end
	end
	return items
end

function onCreatureSay(cid, type, msg)
	local msg = msg:lower()
	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if msgcontains(msg, 'fechar') then
		doSendDialogNpcClose(cid)
		npcHandler:unGreet(cid)
		return true
	end

	for a, b in pairs(gobackmsgs) do
		local gm = string.gsub(b.go, "doka!", "")
		local bm = string.gsub(b.back, "doka!", "")
		if string.find(msg, gm:lower()) or string.find(msg, bm:lower()) then
			return true
		end
	end

	if (msgcontains(msg, 'hi') and getDistanceToCreature(cid) <= 3) then
		if getPlayerStorageValue(cid, 665656) > os.time() or exhaustion.get(cid, 9211) then
			doSendDialogNpc(cid, getNpcId(), "Please wait a few moment before asking me to heal your pokemons again!", "fechar")
			return true
		end

		if getPlayerStorageValue(cid, 52480) >= 1 then
			selfSay("You can't do that while in a Duel!")
			return true
		end



		exhaustion.set(cid, 9211, 5)

		doCreatureAddHealth(cid, getCreatureMaxHealth(cid) - getCreatureHealth(cid))
		doCureStatus(cid, "all", true)
		doSendMagicEffect(getThingPos(cid), 132)

		local mypb = getPlayerSlotItem(cid, 8)

		if #getCreatureSummons(cid) >= 1 then
			if not nurseHealsPokemonOut then
				selfSay("Please, return your pokemon to his ball!")
				return true
			end

			local summon = getCreatureSummons(cid)[1]
			doCreatureAddHealth(summon, getCreatureMaxHealth(summon))
			doSendMagicEffect(getThingPos(summon), 13)
			doCureStatus(summon, "all", false)
		elseif mypb.itemid ~= 0 and isPokeball(mypb.itemid) then
			doItemSetAttribute(mypb.uid, "hp", 1)
			for c = 1, 15 do
				setCD(mypb.uid, "move" .. c, 0)
			end
			if getPlayerStorageValue(cid, 17000) <= 0 and getPlayerStorageValue(cid, 17001) <= 0 and getPlayerStorageValue(cid, 63215) <= 0 then
				for _, b in pairs(pokeballs) do
					if isInArray(b.all, mypb.itemid) then
						doTransformItem(mypb.uid, b.on)
					end
				end
			end
		end

		local bp = getPlayerSlotItem(cid, CONST_SLOT_BACKPACK)
		local balls = getPokeballsInContainerHeal(bp.uid)

		for _, uid in ipairs(balls) do
			doItemSetAttribute(uid, "hp", 1)
			for c = 1, 15 do
				setCD(uid, "move" .. c, 0)
			end
			local this = getThing(uid)
			for _, b in pairs(pokeballs) do
				if isInArray(b.all, this.itemid) then
					doTransformItem(uid, b.on)
				end
			end
		end

		doSendDialogNpc(cid, getNpcId(), "There you go! You and your pokemons are healthy again.", "fechar")
		setPlayerStorageValue(cid, 665656, os.time() + 3)

		if useKpdoDlls then
			doUpdateMoves(cid)
		end
		if useOTClient then
			onPokeHealthChange(cid)
		end
	end
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, onCreatureSay)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())
