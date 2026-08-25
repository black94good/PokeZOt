local max = 7
local eff = 0
function onThink(cid, interval)
if not isCreature(cid) or #getCreatureSummons(cid) <= 0 then return true end

local sum = getCreatureSummons(cid)[1]
if isCreature(sum) and not ehMonstro(getCreatureTarget(cid)) then
   if getDistanceBetween(getThingPos(cid), getThingPos(sum)) > max then
      doTeleportThing(sum, getThingPos(cid), false)
      doSendMagicEffect(getThingPos(sum), eff)
   end
end
return true
end