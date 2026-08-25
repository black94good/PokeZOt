function outfitBase(cid)    
    if getPlayerSex(cid) == 1 then
        doSetCreatureOutfit(cid, {lookType = 510, lookHead = 0, lookAddons = 0, lookLegs = 0, lookBody = 0, lookFeet = 0}, -1)
    else
        doSetCreatureOutfit(cid, {lookType = 511, lookHead = 0, lookAddons = 0, lookLegs = 0, lookBody = 0, lookFeet = 0}, -1)
    end
end

function markPositions(cid)
	if not isPlayer(cid) then return true end
	if isPlayer(cid) then 
		doPlayerAddMapMark(cid, {x = 1065, y = 1114, z = 7}, 4, "Quest: Sample Position")
	
		return true 
	end
end

-- função auxiliar para contar itens dentro do container
function getItemCountInContainer(container, itemid)
	local count = 0
	for i = 0, getContainerSize(container)-1 do
		local item = getContainerItem(container, i)
		if item.itemid == itemid then
			count = count + 1
		end
	end
	return count
end

function iniciais(cid)
    if getPlayerStorageValue(cid, 10000) == 1 then 
        return true 
    end

    doPlayerSetMaxCapacity(cid, 0)
    setCreatureMaxMana(cid, 6)
    doPlayerSetVocation(cid, 1)
    doPlayerAddSoul(cid, -getPlayerSoul(cid))
    setPlayerStorageValue(cid, 19898, 0)
    outfitBase(cid) 
    local starters = {
        [1] = "Bulbasaur",  [2] = "Charmander",  [3] = "Squirtle",
   

    }

    for id, poke in pairs(starters) do
        local storage = 10000 + id
        if getPlayerStorageValue(cid, storage) == 1 then
            if getPlayerStorageValue(cid, 10000) == 1 then
                return true -- Já recebeu
            end

            local btype = "normal"
            addPokeToPlayer(cid, poke, 200, nil, btype)
            -- START Ball System
            doPlayerAddItem(cid, pokeballs.ultra.empty, 100)
            -- END Ball System
            doPlayerAddItem(cid, 12344, 100)
            setPlayerStorageValue(cid, 10000, 1)
            return true
        end
    end

    return false -- Nenhuma storage encontrada
end


