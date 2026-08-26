-- START Pokebar System
MAX_CARRIED_POKEMON = 6

local function collectPokeballs(container, result)
   if not isContainer(container) then return end

   for slot = 0, getContainerSize(container) - 1 do
      local item = getContainerItem(container, slot)
      if isContainer(item.uid) then
         collectPokeballs(item.uid, result)
      elseif isPokeball(item.itemid) and getItemAttribute(item.uid, "poke") then
         table.insert(result, item)
      end
   end
end

function getPlayerPokeballs(cid)
   local result = {}

   if isCreature(cid) then
      local equippedBall = getPlayerSlotItem(cid, CONST_SLOT_FEET)
      if equippedBall.uid > 0 and isPokeball(equippedBall.itemid) and getItemAttribute(equippedBall.uid, "poke") then
         table.insert(result, equippedBall)
      end
      collectPokeballs(getPlayerSlotItem(cid, CONST_SLOT_BACKPACK).uid, result)
   else
      collectPokeballs(cid, result)
   end

   return result
end

function getPlayerPokemonCount(cid)
   return #getPlayerPokeballs(cid)
end

function canPlayerCarryPokemon(cid, amount)
   return getPlayerPokemonCount(cid) + (tonumber(amount) or 1) <= MAX_CARRIED_POKEMON
end

local function getPokebarPortraitId(name)
   local portraitId = fotos[name]
   if not portraitId then return nil end

   if portraitId >= 11137 and portraitId <= 11387 then
      return portraitId - 911
   elseif portraitId >= 12605 then
      return portraitId - 1178
   end

   return portraitId - 928
end

function doUpdatePokemonsBar(cid)
   if not isCreature(cid) then return true end
   if getPlayerStorageValue(cid, 656494) > 0 then return true end

   setPlayerStorageValue(cid, 656494, 1000)
   addEvent(setPlayerStorageValue, 100, cid, 656494, -1)

   local response = {"p#,"}
   local balls = getPlayerPokeballs(cid)
   local order = 0

   for index = 1, #balls do
      doItemEraseAttribute(balls[index].uid, "ballorder")
   end

   for index = 1, #balls do
      if order >= MAX_CARRIED_POKEMON then break end
      local item = balls[index]
      local name = getItemAttribute(item.uid, "poke")
      local portraitId = getPokebarPortraitId(name)

      if portraitId and portraitId >= 9000 then
         order = order + 1
         local hp = math.max(0, math.min(100, math.ceil((tonumber(getItemAttribute(item.uid, "hp")) or 0) * 100)))
         local gender = tonumber(getItemAttribute(item.uid, "gender")) or 0
         doItemSetAttribute(item.uid, "ballorder", order)
         table.insert(response, portraitId.."|"..name.."|"..order.."|"..gender.."|"..hp..",")
      end
   end

   doPlayerSendCancel(cid, table.concat(response))
   return true
end
-- END Pokebar System

function getNewMoveTable(table, n)
if table == nil or not n then return false end

local moves = {table.move1, table.move2, table.move3, table.move4, table.move5, table.move6, table.move7, table.move8, table.move9,
table.move10, table.move11, table.move12}

return moves[n] or false
end


function doUpdateMoves(cid)
if not isCreature(cid) then return true end
local summon = getCreatureSummons(cid)[1]
local ret = {}
table.insert(ret, "12&,")
if not summon then
   for a = 1, 12 do
       table.insert(ret, "n/n,")
   end
   doPlayerSendCancel(cid, table.concat(ret))
   addEvent(doUpdateCooldowns, 100, cid)
return true
end
if isTransformed(summon) then  --alterado v1.9
   moves = movestable[getPlayerStorageValue(summon, 1010)]
else                                                       
   moves = movestable[getCreatureName(summon)]
end
for a = 1, 12 do
    local b = getNewMoveTable(moves, a)
    if b then
       table.insert(ret, b.name..",")
    else
       table.insert(ret, "n/n,")
    end
end
doPlayerSendCancel(cid, table.concat(ret))
addEvent(doUpdateCooldowns, 100, cid)
end

function doUpdateCooldowns(cid)
if not isCreature(cid) then return true end
local a = getPlayerSlotItem(cid, 8)
local ret = {}
table.insert(ret, "12|,")
if a.uid <= 0 or #getCreatureSummons(cid) <= 0 then
   for cds = 1, 12 do
       if useOTClient then table.insert(ret, "-1|0,") else table.insert(ret, "-1,") end  
   end
   doPlayerSendCancel(cid, table.concat(ret))
return true
end
for cds = 1, 12 do                                                         
    ----
    local summon = getCreatureSummons(cid)[1]
    if summon and getPlayerStorageValue(summon, 212123) >= 1 then
       cdzin = "cm_move"..cds
    else                       
       cdzin = "move"..cds
    end
    ----
    if isTransformed(summon) then  --alterado v1.9
       moves = movestable[getPlayerStorageValue(summon, 1010)]
    else                                                       
       moves = movestable[getCreatureName(summon)]
    end
    local b = getNewMoveTable(moves, cds)
    if not b then
       for cds = 1, 12 do
           if useOTClient then table.insert(ret, "-1|0,") else table.insert(ret, "-1,") end   --alterado v1.9
       end
       doPlayerSendCancel(cid, table.concat(ret))
    return true
    end
    ----
    if getCD(a.uid, cdzin) > 0 then
       if (useOTClient and b) then table.insert(ret, (getCD(a.uid, cdzin)).."|"..b.level..",") else table.insert(ret, (getCD(a.uid, cdzin))..",") end
    else
       if (useOTClient and b) then table.insert(ret, "0|"..b.level..",") else table.insert(ret, "0,") end  
    end
end
doPlayerSendCancel(cid, table.concat(ret))                                             
end

function getBallsAttributes(item)
-- START Ball Look System
-- START Pokemon Level and Gender System
local t = {"poke", "gender", "nick", "boost", "happy", "hp", "description", "capturedAt", "capturedBy", "pokeLevel", "pokeExp", "pokeExperience", "currenthp", "maxhp", "ball", "ballstate", "morta", "transBegin", "hunger", "transLeft", "transTurn", "transOutfit", "transName", 
"trans", "light", "blink", "move1", "move2", "move3", "move4", "move5", "move6", "move7", "move8", "move9", "move10", "move11", "move12", "ballorder", 
"hands", "aura", "burn", "burndmg", "poison", "poisondmg", "confuse", "sleep", "miss", "missSpell", "missEff", "fear", "fearSkill", "silence", 
"silenceEff", "stun", "stunEff", "stunSpell", "paralyze", "paralyzeEff", "slow", "slowEff", "leech", "leechdmg", "Buff1", "Buff2", "Buff3", "Buff1skill",
"Buff2skill", "Buff3skill", "control", "unique", "task", "lock"}
-- END Pokemon Level and Gender System
-- END Ball Look System
local ret = {}
for a = 1, #t do
if getItemAttribute(item, t[a]) == "hands" then
return
end
ret[t[a]] = getItemAttribute(item, t[a]) or false
end
return ret
end

function doChangeBalls(cid, item1, item2)
if not isCreature(cid) then return true end
if item1.uid == item2.uid then
   if #getCreatureSummons(cid) <= 0 then
      doGoPokemon(cid, getPlayerSlotItem(cid, 8))
   else
      doReturnPokemon(cid, getCreatureSummons(cid)[1], getPlayerSlotItem(cid, 8), pokeballs[getPokeballType(getPlayerSlotItem(cid, 8).itemid)].effect)
   end
return true
end

if item1.uid > 0 and item2.uid > 0 then
   local io = getBallsAttributes(item1.uid)
   local it = getBallsAttributes(item2.uid)
   for a, b in pairs (io) do
       if b then
          doItemSetAttribute(item2.uid, a, b)
       else
          doItemEraseAttribute(item2.uid, a)
       end
   end
   for a, b in pairs (it) do
       if b then
          doItemSetAttribute(item1.uid, a, b)
       else
          doItemEraseAttribute(item1.uid, a)
       end
   end
   local id = item2.itemid
   doTransformItem(item2.uid, item1.itemid)
   doTransformItem(item1.uid, id)
   doGoPokemon(cid, getPlayerSlotItem(cid, 8))
else
   local id = item2.itemid
   local b = getBallsAttributes(item2.uid)
   local a = doPlayerAddItem(cid, 2643, false)
   for c, d in pairs (b) do
       if d then
          doItemSetAttribute(a, c, d)
       else
          doItemEraseAttribute(a, c)
       end
   end
   doRemoveItem(item2.uid, 1)
   doTransformItem(a, id)
   doGoPokemon(cid, getPlayerSlotItem(cid, 8))
end
end
