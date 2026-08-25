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
------------#Configurações#----------------
local config = {
	tp1 = {x=903, y=1005, z=15}, -- coordenadas pra onde ele irá ao falar aonde está "boxs".
	item1 = 14573,  -- id do item 1
	qtd1 = 1, -- quantidade a ser removida do item 1

}
----------#Fim das configurações#----------

------------#*#Início do NPC#*#--------------
if msgcontains(msg, 'boxs') then -- o que ele tem que falar.
	if doPlayerRemoveItem(cid, config.item1, config.qtd1) then 
		doTeleportThing(cid, config.tp1) -- não mexa.
	else
		selfSay("Você não tem "..config.qtd1.." {"..getItemNameById(config.item1).."s}.", cid) -- msg que retorna caso ele não tenha o item.
	end
end
------------#*#Fim do NPC#*#--------------
return true
end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())  