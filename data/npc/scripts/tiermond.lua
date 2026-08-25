local keywordHandler = KeywordHandler:new() 
local npcHandler = NpcHandler:new(keywordHandler) 
NpcSystem.parseParameters(npcHandler) 
local talkState = {} 
 
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end 
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end 
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end 
function onThink() npcHandler:onThink() end 
 
function creatureSayCallback(cid, type, msg) 
if(not npcHandler:isFocused(cid)) then 
return false  
end  
 
local talkUser = NPCHANDLER_CONVbehavior == CONVERSATION_DEFAULT and 0 or cid  
 
-- Conversa Jogador/NPC  
if(msgcontains(msg, 'offer') or msgcontains(msg, 'Offer')) then
selfSay('I sell metal coat.', cid) 
elseif(msgcontains(msg, 'X-Attack T7') or msgcontains(msg, 'x-attack t7')) then
selfSay('O X Attack T7 custa 15 diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 1 
elseif(msgcontains(msg, 'X-Defense T7') or msgcontains(msg, 'x-defense t7')) then
selfSay('O X Defense T7 custa 15 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 2
elseif(msgcontains(msg, 'X-Boost T7') or msgcontains(msg, 'x-boost t7')) then
selfSay('O X Boost T7 custa 15 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 3
elseif(msgcontains(msg, 'X-Return') or msgcontains(msg, 'x-return t7')) then
selfSay('o X Return T7 custa 30 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 4
elseif(msgcontains(msg, 'Y-Regeneration T7') or msgcontains(msg, 'y-regeneration t7')) then
selfSay('O Y Regeneration T7 custa 20 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 5
elseif(msgcontains(msg, 'Y-Cure T7') or msgcontains(msg, 'y-cure t7')) then
selfSay('O Y Cure T7 custa 20 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 6
 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 2145, 15) == true) then  
selfSay('Obrigado! Você recebeu o X-Attack T7', cid) 
doPlayerAddItem(cid, 13954, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 2) then  
if(doPlayerRemoveItem(cid, 2145, 15) == true) then  
selfSay('Obrigado! Você recebeu um X-Defense T7.', cid) 
doPlayerAddItem(cid, 13982, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 3) then  
if(doPlayerRemoveItem(cid, 2145, 15) == true) then  
selfSay('Obrigado! Você recebeu um X-Boost T7.', cid) 
doPlayerAddItem(cid, 13996, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 4) then  
if(doPlayerRemoveItem(cid, 2145, 30) == true) then  
selfSay('Obrigado! Você recebeu um X-Return T7.', cid) 
doPlayerAddItem(cid, 13975, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 5) then  
if(doPlayerRemoveItem(cid, 2145, 20) == true) then  
selfSay('Obrigado! Você recebeu um Y-Regeneration T7.', cid) 
doPlayerAddItem(cid, 13947, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 6) then  
if(doPlayerRemoveItem(cid, 2145, 20) == true) then  
selfSay('Obrigado! Você recebeu um Y-Cure T7.', cid) 
doPlayerAddItem(cid, 13989, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end

end 
return TRUE
end
 
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback) 
npcHandler:addModule(FocusModule:new())