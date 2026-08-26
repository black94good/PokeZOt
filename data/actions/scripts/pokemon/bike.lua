-- START Pokemon Transportation System
local function BikeSpeedOn(cid, t)
setPlayerStorageValue(cid, t.s, 1)
doChangeSpeed(cid, -getCreatureSpeed(cid))
doChangeSpeed(cid, t.speed)
end

local function BikeSpeedOff(cid, t)
setPlayerStorageValue(cid, t.s, -1)
doRegainSpeed(cid)
end

local t = {text='Bike ON!', dtext='Bike OFF!', s=5700, speed = 2000}

function onUse(cid, item, fromPosition, itemEx, toPosition)

local pos = getThingPos(cid)

-- Desmontar deve funcionar mesmo se outra storage ficou inconsistente.
if getPlayerStorageValue(cid, t.s) >= 1 then
   doSendMagicEffect(pos, 177)
   doCreatureSay(cid, t.dtext, TALKTYPE_SAY)
   doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, 'Voce saiu da bike.')
   BikeSpeedOff(cid, t)
   -- START Pokemon Transportation Outfit Colors
   restorePokemonTransportBaseOutfit(cid, true)
   -- END Pokemon Transportation Outfit Colors
   return true
end

if #getCreatureSummons(cid) >= 1 then
return doPlayerSendCancel(cid, "Recolha seu Pokemon antes de usar a bike.")
end
if getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 or
getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 75846) >= 1 or
getPlayerStorageValue(cid, 6598754) >= 1 or getPlayerStorageValue(cid, 6598755) >= 1 then
   return doPlayerSendCancel(cid, "You can't do that right now.")
end

doSendMagicEffect(pos, 177)
doCreatureSay(cid, t.text, TALKTYPE_SAY)
doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, 'Voce Montou na bike, Lembrando que nao pode usar pokemon na bike.')
-- START Pokemon Transportation Outfit Colors
savePokemonTransportBaseOutfit(cid)
-- END Pokemon Transportation Outfit Colors
BikeSpeedOn(cid, t)
applyPokemonTransportOutfit(cid, getPlayerSex(cid) == 1 and 162 or 161)
return true
end
-- END Pokemon Transportation System
