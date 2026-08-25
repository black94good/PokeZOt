local EFFECTS = {
    --[OutfitID] = {Effect}
    ["Magmar"] = 35,   
    ["Jynx"] = 17,          --alterado v1.5
    ["Shiny Jynx"] = 17, 
    ["Piloswine"] = 205,  --alterado v1.8
    ["Swinub"] = 205,   
}

local function volta(cid, init)
    
if getPlayerSlotItem(cid, CONST_SLOT_FEET).uid > 0 then
local item = getPlayerSlotItem(cid, CONST_SLOT_FEET)
    pb = getPlayerSlotItem(cid, 8).uid
    megax = getItemAttribute(pb, "poke")    
    n = getCreatureName(cid)
    heldy = getItemAttribute(pb, "heldy")   
    heldx = getItemAttribute(pb, "heldx")
    addon = getItemAttribute(pb, "addon") or 0



        if getPlayerStorageValue(cid, In_Exclusive) >= 1 then
        if getPlayerStorageValue(cid, Exclusive) ~= nill then
            local storage = getPlayerStorageValue(cid, Exclusive)
            local array = PokesObrigatorios[storage].pokemons
            if not isInArray(array, megax) then 
                local vazio = {}    
                local Insert = PokesObrigatorios[getPlayerStorageValue(cid, Exclusive)].pokemons
                for i = 1, #Insert, 1 do
                    table.insert(vazio, Insert[i]..", ") 
                end
                    Escrever(cid, "Nessa quest apenas esses pokémons são permitidos: "..table.concat(vazio))
            return true
            end
        end
    end


    if pb == nill then 
    return true end



if not getItemAttribute(item.uid, "pokeLevel") then
    doItemSetAttribute(item.uid, "pokeLevel", 1)
end



        
        if exhaustion.get(cid, 6666) and exhaustion.get(cid, 6666) > 0 then return true end

if getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 17001) >= 1 or getPlayerStorageValue(cid, 63215) >= 1 
or getPlayerStorageValue(cid, 75846) >= 1 or getPlayerStorageValue(cid, 5700) >= 1  then    --alterado v1.9 <<
   return true                                                                                                                        
end

local ballName = getItemAttribute(item.uid, "poke")
local btype = getPokeballType(item.itemid)
local usando = pokeballs[btype].use

local effect = pokeballs[btype].effect
    if not effect then
        effect = 21
    end
    
if not getItemAttribute(item.uid, "tadport") and ballName then
    doItemSetAttribute(item.uid, "tadport", fotos[ballName])
end

unLock(item.uid) 

if item.itemid == usando then                           
    if #getCreatureSummons(cid) > 1 and getPlayerStorageValue(cid, 212124) <= 0 then     --alterado v1.6
       if getPlayerStorageValue(cid, 637501) == -2 or getPlayerStorageValue(cid, 637501) >= 1 then  
          BackTeam(cid)       
       end
    end   
    if #getCreatureSummons(cid) <= 0 then
        if isInArray(pokeballs[btype].all, item.itemid) then
            doTransformItem(item.uid, pokeballs[btype].off)
            doItemSetAttribute(item.uid, "hp", 0)
            doPlayerSendCancel(cid, "This pokemon is fainted.")
            return true
        end
    end

    local cd = getCD(item.uid, "blink", 30)
    if cd > 0 then
       setCD(item.uid, "blink", 0)
    end
    
    local z = getCreatureSummons(cid)[1]

    if getCreatureCondition(z, CONDITION_INVISIBLE) and not isGhostPokemon(z) then
       return true
    end
    doReturnPokemon(cid, z, item, effect)
    
        end
        
        if init then
            if item.itemid == pokeballs[btype].on then
                if item.uid ~= getPlayerSlotItem(cid, CONST_SLOT_FEET).uid then
        doPlayerSendCancel(cid, "You must put your pokeball in the correct place!")
    return TRUE
    end

    local thishp = getItemAttribute(item.uid, "hp")

    if thishp <= 0 then
        if isInArray(pokeballs[btype].all, item.itemid) then
            doTransformItem(item.uid, pokeballs[btype].off)
            doItemSetAttribute(item.uid, "hp", 0)
            doPlayerSendCancel(cid, "This pokemon is fainted.")
            return true
        end
    end
    
    
    
    pokemon = getItemAttribute(item.uid, "poke")

    if not pokes[pokemon] then
    return true
    end

    local x = pokes[pokemon]
    local boost = getItemAttribute(item.uid, "boost") or 0


    
        
        if #getCreatureSummons(cid) < 1 and getPlayerStorageValue(cid, 95342) < 1 then
            doSummonMonster(cid, pokemon)
        end
        

                   --CD do Revive (10 = 10 segundos, 20 = 20 segundos, etc). NÃ£o precisa alterar mais nada!




    local pk = getCreatureSummons(cid)[1]
    if not isCreature(pk) then return true end
    
    ------------------------passiva hitmonchan------------------------------
    if isSummon(pk) then                                                  --alterado v1.8 \/
       if pokemon == "Shiny Hitmonchan" or pokemon == "Hitmonchan" then
          if not getItemAttribute(item.uid, "hands") then
             doSetItemAttribute(item.uid, "hands", 0)
          end
          local hands = getItemAttribute(item.uid, "hands")
          doSetCreatureOutfit(pk, {lookType = hitmonchans[pokemon][hands].out}, -1)
       end
    end
    
    



    --------------------------------------------------------------------------      

    if getCreatureName(pk) == "Ditto" or getCreatureName(pk) == "Shiny Ditto" then --edited

        local left = getItemAttribute(item.uid, "transLeft")
        local name = getItemAttribute(item.uid, "transName")

        if left and left > 0 then
            setPlayerStorageValue(pk, 1010, name)
            doSetCreatureOutfit(pk, {lookType = getItemAttribute(item.uid, "transOutfit")}, -1)
            addEvent(deTransform, left * 1000, pk, getItemAttribute(item.uid, "transTurn"))
            doItemSetAttribute(item.uid, "transBegin", os.clock())
        else
         
            setPlayerStorageValue(pk, 1010, getCreatureName(pk) == "Ditto" and "Ditto" or "Shiny Ditto")     --edited
        end
    end


    

    if isGhostPokemon(pk) then doTeleportThing(pk, getPosByDir(getThingPos(cid), math.random(0, 7)), false) end

    doCreatureSetLookDir(pk, 2)


    if getPlayerStorageValue(cid, 45455498) >= 1 then
            DeixarHard(pk, item.uid, true, true, true)
    elseif getPlayerStorageValue(cid, 4545549) >= 1 then
            StatusPvp(pk, item.uid, true, true, true)   
    elseif getPlayerStorageValue(cid, divineStorage) >= 1 then
            balancearDivine(pk, item.uid, true, true, true)         
    else
        adjustStatus(pk, item.uid, true, true, true)
    end

    doRegenerateWithY(getCreatureMaster(pk), pk)
    doCureWithY(getCreatureMaster(pk), pk)


    doTransformItem(item.uid, item.itemid+1)

    local pokename = getPokeName(pk) --alterado v1.7 



if isPlayer(cid) then   
    local mgo = gobackmsgs[math.random(1, #gobackmsgs)].go:gsub("doka", pokename)
    doCreatureSay(cid, mgo, TALKTYPE_MONSTER)
    
    if getItemAttribute(item.uid, "ballorder") then
        doPlayerSendCancel(cid, "KGT,"..getItemAttribute(item.uid, "ballorder").."|".."0")
    end

    local pk = getCreatureSummons(cid)[1]
    local pb = getPlayerSlotItem(cid, 8).uid
    local look = getItemAttribute(pb, "addon")
    
    if not look then
        doSetItemAttribute(pb, "addon", 0)  
    end
                
    if look and look > 0 then
        doSetCreatureOutfit(pk, {lookType = look}, -1)
    end

if getPlayerStorageValue(cid, 87874) >= 1 then 
    doSendMagicEffect(getCreaturePosition(pk), effect)
    doSendMagicEffect(getCreaturePosition(pk), 189)
    setPlayerStorageValue(cid, 87874, 0)
elseif getPlayerStorageValue(cid, 87875) >= 1 then
    doSendMagicEffect(getCreaturePosition(pk), effect)
    doSendMagicEffect(getCreaturePosition(pk), 18)
    setPlayerStorageValue(cid, 87875, 0)
else
    doSendMagicEffect(getCreaturePosition(pk), effect)
end

    local pk = getCreatureSummons(cid)[1]

    
end






    
    if useOTClient then
       doPlayerSendCancel(cid, '12//,show') --alterado v1.7
    end
                end
            end
        end
        if useKpdoDlls then
        doUpdateMoves(cid)
    end
return true
end





function onSay(cid, words, param, channel)

    local pbItem = getPlayerSlotItem(cid, 8)
    if pbItem.uid <= 0 then
        return true
    end

    local pb = pbItem.uid
    local megax = getItemAttribute(pb, "poke")
    local dono = getItemAttribute(pb, "dono") 
    local n = getCreatureName(cid)
    local heldy = getItemAttribute(pb, "heldy")   
    local heldx = getItemAttribute(pb, "heldx")
    local addon = getItemAttribute(pb, "addon") or 0


if getPlayerStorageValue(cid, 912351) > os.time () and getPlayerStorageValue(cid, 95342) ~= 1 then
    doPlayerSendCancel(cid, "Espere "..getPlayerStorageValue(cid, 912351) - os.time ().." segundo(s) para usar novamente")
return true
end


local cd = 1
    if getPlayerStorageValue(cid, 95342) ~= 1 then
        setPlayerStorageValue(cid, 912351, os.time () + cd)
    end    

    if getPlayerSlotItem(cid, CONST_SLOT_FEET).uid > 0 then
        if getItemAttribute(getPlayerSlotItem(cid, CONST_SLOT_FEET).uid, "ballorder") == tonumber(param) then
            volta(cid, true)
            return true
        else
            volta(cid, false)
        end
    end
    doMoveBar(cid, tonumber(param))
    volta(cid, true)
    return true
end