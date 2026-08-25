function onUse(cid, item, frompos, item2, topos)

if isPlayer(item2.uid) then
return doPlayerSendCancel(cid, "Você só pode usar a rare candy em seu pokemon!")
end

if not isCreature(item2.uid) then
return doPlayerSendCancel(cid, "Você só pode usar a rare candy em seu pokemon!")
end

if not isPlayer(getCreatureMaster(item2.uid)) then
return doPlayerSendCancel(cid, "Você não pode usar rare candy em pokemons selvagens.")
end
local cfg = {
    qnt = 1,       --Quantos boosts o pokémon irá receber.
    max = 300,      --Boost máximo do seu servidor.
    chance = 40,   --Chance de falhar, em %
    boost_fail = 100,  --A partir de quantos boosts poderá falhar.
}
 
local myball = getPlayerSlotItem(cid, 8).uid
local summon = getCreatureSummons(cid)[1]
local boost = getItemAttribute(myball, "boost") or 0
 
    if myball <= 0 then
        return doPlayerSendCancel(cid, "Coloque um pokémon no Main Slot!")
    elseif #getCreatureSummons(cid) <= 0 then
        return doPlayerSendCancel(cid, "Você precisa estar usando seu pokémon para conseguir boostá-lo!")
    elseif boost >= cfg.max then
        return doPlayerSendCancel(cid, "Seu pokémon já se encontra no nível máximo de boost!")
    end
    
    if boost >= cfg.boost_fail then
        if math.random(1, 100) <= cfg.chance then
            doItemSetAttribute(myball, "boost", (boost + cfg.qnt))
            doSendAnimatedText(getThingPos(summon), "UP BOOST", 215)
            doPlayerSendTextMessage(cid, 27, "Seu pokémon avançou do nível [+"..tonumber(boost).."] de boost para o nível [+"..tonumber(boost + 1).."].")
            doRemoveItem(item.uid, 1)
        else
            doSendAnimatedText(getThingPos(summon), "Falhou!", 215)
            doPlayerSendTextMessage(cid, 27, "Sua boost stone falhou!")
            doRemoveItem(item.uid, 1)
        end
    else
        doItemSetAttribute(myball, "boost", (boost + cfg.qnt))
        doSendAnimatedText(getThingPos(summon), "UP BOOST", 215)
        doPlayerSendTextMessage(cid, 27, "Seu pokémon avançou do nível [+"..tonumber(boost).."] de boost para o nível [+"..tonumber(boost + 1).."].")
        doRemoveItem(item.uid, 1)
    end
    return true
end