local function BikeSpeedOn(cid, t)                  
setPlayerStorageValue(cid, t.s, t.speed) 
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
 
if #getCreatureSummons(cid) >= 1 then
return doPlayerSendCancel(cid, "Retorna seu Pokemon.")
end
if getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 or 
getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 75846) >= 1 or
getPlayerStorageValue(cid, 6598754) >= 1 or getPlayerStorageValue(cid, 6598755) >= 1 then   --alterado v1.9
   return doPlayerSendCancel(cid, "You can't do that right now.")
end
 
if getPlayerStorageValue(cid, t.s) <= 0 then
   doSendMagicEffect(pos, 177)
   doCreatureSay(cid, t.text, 19)
   doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, 'Voce Montou na bike, Lembrando que nao pode usar pokemon na bike.')
   BikeSpeedOn(cid, t)
   if getPlayerSex(cid) == 1 then
      doSetCreatureOutfit(cid, {lookType = 1676}, -1)
   else
       doSetCreatureOutfit(cid, {lookType = 1675}, -1)
   end
else
   doSendMagicEffect(pos, 177)
   doCreatureSay(cid, t.dtext, 19)
   doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_RED, 'Voce saio da bike.')
   BikeSpeedOff(cid, t)
   doRemoveCondition(cid, CONDITION_OUTFIT)
end
return true
end