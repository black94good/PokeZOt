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
elseif(msgcontains(msg, 'Rare Candy') or msgcontains(msg, 'rare candy')) then
selfSay('As 100 Rare candy custa 5 diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 1 
elseif(msgcontains(msg, 'master ball') or msgcontains(msg, 'Master Ball')) then
selfSay('A Master Ball custa 20 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 2
elseif(msgcontains(msg, 'shiny poke box 1') or msgcontains(msg, 'shiny poke box 1')) then
selfSay('A Shiny Poke Box +1 custa 10 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 3
elseif(msgcontains(msg, 'shiny poke box 2') or msgcontains(msg, 'shiny poke box 2')) then
selfSay('A Shiny Poke Box +2 custa 15 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 4
elseif(msgcontains(msg, 'shiny poke box 3') or msgcontains(msg, 'shiny poke box 3')) then
selfSay('A Shiny Poke Box +3 custa 25 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 5
elseif(msgcontains(msg, 'Bike') or msgcontains(msg, 'bike')) then
selfSay('A Bike custa 5 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 6
elseif(msgcontains(msg, 'Cupom') or msgcontains(msg, 'cupom')) then
selfSay('o Cupom custa 5 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 7
elseif(msgcontains(msg, 'Mega Box') or msgcontains(msg, 'mega box')) then
selfSay('A Mega Box custa 50 Diamond, quer mesmo comprar?', cid) 
talkState[talkUser] = 8
 
-- Confirmação da Compra  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 1) then  
if(doPlayerRemoveItem(cid, 2145, 5) == true) then  
selfSay('Obrigado! Você recebeu 100 rare candy', cid) 
doPlayerAddItem(cid, 14261, 100)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end  
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 2) then  
if(doPlayerRemoveItem(cid, 2145, 20) == true) then  
selfSay('Obrigado! Você recebeu uma Master Ball.', cid) 
-- START Ball System
doPlayerAddItem(cid, pokeballs.dark.empty, 1)
-- END Ball System
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 3) then  
if(doPlayerRemoveItem(cid, 2145, 10) == true) then  
selfSay('Obrigado! Você recebeu uma Shiny Poke Box +1.', cid) 
doPlayerAddItem(cid, 14337, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 4) then  
if(doPlayerRemoveItem(cid, 2145, 15) == true) then  
selfSay('Obrigado! Você recebeu uma Shiny Poke Box +2.', cid) 
doPlayerAddItem(cid, 14338, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 5) then  
if(doPlayerRemoveItem(cid, 2145, 25) == true) then  
selfSay('Obrigado! Você recebeu uma Shiny Poke Box +3.', cid) 
doPlayerAddItem(cid, 14339, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 6) then  
if(doPlayerRemoveItem(cid, 2145, 5) == true) then  
selfSay('Obrigado! Você recebeu uma Bike.', cid) 
doPlayerAddItem(cid, 12420, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 7) then  
if(doPlayerRemoveItem(cid, 2145, 5) == true) then  
selfSay('Obrigado! Você recebeu um Cupom.', cid) 
doPlayerAddItem(cid, 14573, 1)
talkState[talkUser] = 0 
else  
selfSay('Você não possui diamonds necessarios para essa compra.', cid) 
talkState[talkUser] = 0  
end
elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 8) then  
if(doPlayerRemoveItem(cid, 2145, 50) == true) then  
selfSay('Obrigado! Você recebeu uma Mega Box.', cid) 
doPlayerAddItem(cid, 14577, 1)
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
