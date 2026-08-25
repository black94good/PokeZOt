local boxs = {x=903, y=802, z=15}; -- Pra onde vai ser teleportado
local money = 100000000 -- Preço

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}

function onCreatureAppear(cid)				npcHandler:onCreatureAppear(cid)			end
function onCreatureDisappear(cid) 			npcHandler:onCreatureDisappear(cid)			end
function onCreatureSay(cid, type, msg)			npcHandler:onCreatureSay(cid, type, msg)		end
function onThink()					npcHandler:onThink()					end

function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if msgcontains(msg:lower(), 'boxs') or msgcontains(msg:lower(), 'Boxs') then
		selfSay('you are sure?', cid)
		talkState[talkUser] = 1


	elseif msgcontains(msg:lower(), 'yes') and talkState[talkUser] == 1 then
		if getPlayerLevel(cid) >= 150 then
			if doPlayerRemoveMoney(cid, money) then
				selfSay('Go!!', cid)
				doTeleportThing(cid, boxs)
				talkState[talkUser] = 0	
			else
				selfSay('Você não possui Dinheiro...', cid)
				talkState[talkUser] = 0
			end
		else
			selfSay('você não é level 150 ainda.')
			talkState[talkUser] = 0
		end

		
	elseif msgcontains(msg:lower(), 'no') and talkState[talkUser] == 1 or talkState[talkUser] == 2 then
		selfSay('Bye!!', cid)
		talkState[talkUser] = 0
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())