function onStepIn(cid, item, position, lastPosition, fromPosition, toPosition, actor)
if isSummon(cid) or isMonster(cid) then return false end
-- START Ball System
local uballs = getPlayerItemCount(cid, pokeballs.ultra.empty)
local pballs = getPlayerItemCount(cid, pokeballs.normal.empty)
local gballs = getPlayerItemCount(cid, pokeballs.great.empty)
local sballs = getPlayerItemCount(cid, pokeballs.super.empty)
local safballs = getPlayerItemCount(cid, pokeballs.saffari.empty)
local dballs = getPlayerItemCount(cid, pokeballs.dark.empty)
-- END Ball System
if uballs > 0 or pballs > 0 or sballs > 0 or gballs > 0 or safballs > 0 or dballs > 0 then
doPlayerSendTextMessage(cid,22,"Você não pode entrar aqui com pokeballs!")
doTeleportThing(cid, fromPosition, TRUE)
end
if item.actionid == 25708 and getPlayerLevel(cid) <= 119 then
doTeleportThing(cid, fromPosition, TRUE)
doPlayerSendTextMessage(cid,22,"Somente level 120+ pode entrar aqui!")
doSendMagicEffect(position, 21)
end
end
