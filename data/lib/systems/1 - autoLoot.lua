-- Criado por Thalles Vitor --
-- Sistema de Auto Loot Janela --

local optionsAvaiable = {"Items", "Stones", "Multiverse"} -- opcoes do auto loot disponiveis (adicione la embaixo e aqui)
local autoloot_send_options_opcodes = 170 -- opcode que vai enviar de volta apos receber
local autoloot_send_items_opcode = 106 -- opcode que vai enviar de volta apos receber (enviar items do aloot)
local autoloot_send_destroyCHILD_opcode = 107 -- opcode que vai enviar de volta apos receber (remover os widgets antigos e criar novos)
local autoloot_send_items_opcode2 = 108 -- opcode que vai enviar de volta apos receber (enviar items do aloot (troca de categoria))
local autoloot_send_items_added_opcode = 109 -- opcode que vai enviar de volta apos receber (enviar items adicionados pelo player)

-- Categorias de Items
local items = {
    ["Items"] =
    {
        item_id = {12194, 2145, 12142, 12148, 12149, 12150, 12151, 12152, 12153, 12154, 12155, 12157, 12158, 12159, 12161, 12162, 12163, 12165, 12170, 12171, 12173, 12176, 12177}, -- id dos items
        item_name = {"future orb", "Game Diamond", "iron piece", "gyarados tail", "teal feather", "yellow feather", "red feather", "pot of lava", "bag of pollem", "bulb", "pair of leaves",
        "nail", "turtle hull", "dragon tooth", "water gem", "essence of fire", "seed", "bottle of poison", "water pendant", "pot of moss bug", "apple bite", "electric box",
        "sandbag"}, -- nome dos items
    },

    ["Stones"] =
    {
        item_id = {11442, 11447, 11443, 11444, 11445, 11446, 11448, 11449, 11450, 11451, 11452, 11453, 11454, 11441, 12244}, -- id dos items
        item_name = {"Water Stone", "Fire Stone", "Venom Stone", "Thunder Stone", "Rock Stone", "Punch Stone", "Coccon Stone", "Crystal Stone",
        "Darkness Stone", "Earth Stone", "Enigma Stone", "Heart Stone", "Ice Stone", "Leaf Stone", "Ancient Stone"}, -- nome dos items
    },


}

-- Items disponiveis do auto loot que sao os de cima (nome do item e id: id do item)
local items_avaiables = {
    -- Stones
    ["Water Stone"] = {id = 11442},
    ["Fire Stone"] = {id = 11447},
    ["Venom Stone"] = {id = 11443},
    ["Thunder Stone"] = {id = 11444},
    ["Rock Stone"] = {id = 11445},
    ["Punch Stone"] = {id = 11446},
    ["Coccon Stone"] = {id = 11448},
    ["Crystal Stone"] = {id = 11449},
    ["Darkness Stone"] = {id = 11450},
    ["Earth Stone"] = {id = 11451},
    ["Enigma Stone"] = {id = 11452},
    ["Heart Stone"] = {id = 11453},
    ["Ice Stone"] = {id = 11454},
    ["Leaf Stone"] = {id = 11441},
    ["Ancient Stone"] = {id = 12244},

    -- Items
	["Game Diamond"] = {id = 2145},
    ["Pink Mond"] = {id = 22048},
    ["Fluido"] = {id = 17404},
    ["iron piece"] = {id = 12142},
    ["gyarados tail"] = {id = 12148},
    ["teal feather"] = {id = 12149},
    ["yellow feather"] = {id = 12150},
    ["red feather"] = {id = 12151},
    ["pot of lava"] = {id = 12152},
    ["bag of pollem"] = {id = 12153},
    ["bulb"] = {id = 12154},
    ["pair of leaves"] = {id = 12155},
    ["nail"] = {id = 12157},
    ["turtle hull"] = {id = 12158},
    ["dragon tooth"] = {id = 12159},
    ["water gem"] = {id = 12161},
    ["essence of fire"] = {id = 12162},
    ["seed"] = {id = 12163},
    ["bottle of poison"] = {id = 12165},
    ["water pendant"] = {id = 12170},
    ["pot of moss bug"] = {id = 12171},
    ["apple bite"] = {id = 12173},
    ["electric box"] = {id = 12176},
    ["sandbag"] = {id = 12177},
    ["future orb"] = {id = 12194},


}

-- Receber o opcode vindo do otclient
function onReceiveFirstOpcode(playerId, param)
    if not isPlayer(playerId) then
        --print("Player n�o encontrado!")
        return false
    end

    if param == "Items" then
        for i = 1, #optionsAvaiable do
            doSendPlayerExtendedOpcode(playerId, autoloot_send_options_opcodes, optionsAvaiable[i])
        end

        sendAutoLootItems(playerId, param)
    end

    if param == "Stones" then
        for i = 1, #optionsAvaiable do
            doSendPlayerExtendedOpcode(playerId, autoloot_send_options_opcodes, optionsAvaiable[i])
        end

        sendAutoLootItems(playerId, param)
        onReceiveItemsAdded(playerId)
    end
    if param == "Multiverse" then
        for i = 1, #optionsAvaiable do
            doSendPlayerExtendedOpcode(playerId, autoloot_send_options_opcodes, optionsAvaiable[i])
        end

        sendAutoLootItems(playerId, param)
        onReceiveItemsAdded(playerId)
    end

    return true
end

-- Enviar a lista de items de autoloot
function sendAutoLootItems(playerId, category)
    if not isPlayer(playerId) then
        --print("Player n�o encontrado!")
        return false
    end

    local item_list = items[category]
    if not item_list then
        print("[AUTO LOOT ERROR] - The category with name: " .. category .. " not exist in table.")
        return false
    end

    local itemid = item_list.item_id
    local itemname = item_list.item_name
    if #itemid < #itemname then
        print("[AUTO LOOT ERROR] - The size of the list itemid is different of the size list itemname.")
        return false
    end

    if #itemname < #itemid then
        print("[AUTO LOOT ERROR] - The size of the list itemname is different of the size list itemid.")
        return false
    end

    for i = 1, #itemid do
        doSendPlayerExtendedOpcode(playerId, autoloot_send_items_opcode, getItemInfo(itemid[i]).clientId.."@"..itemname[i].."@"..tostring(getAutoLootEnabled(playerId)).."@")
    end
    return true
end

-- Mudar a categoria do auto loot
function onChangeCategory(playerId, category)
    if not isPlayer(playerId) then
        --print("Player n�o encontrado!")
        return false
    end

    local item_list = items[category]
    if not item_list then
        print("[AUTO LOOT ERROR] - The category with name: " .. category .. " not exist in table.")
        return false
    end

    doSendPlayerExtendedOpcode(playerId, autoloot_send_destroyCHILD_opcode, "destroy".."@")
    
    local itemid = item_list.item_id
    local itemname = item_list.item_name
    if #itemid < #itemname then
        print("[AUTO LOOT ERROR] - The size of the list itemid is different of the size list itemname.")
        return false
    end

    if #itemname < #itemid then
        print("[AUTO LOOT ERROR] - The size of the list itemname is different of the size list itemid.")
        return false
    end

    for i = 1, #itemid do
        doSendPlayerExtendedOpcode(playerId, autoloot_send_items_opcode2, getItemInfo(itemid[i]).clientId.."@"..itemname[i].."@"..tostring(getAutoLootEnabled(playerId)).."@")
    end

    --onReceiveItemsAdded(playerId)
    return true
end

-- Receber os items adicionados pelo jogador
function onReceiveItemsAdded(playerId)
    if not isPlayer(playerId) then
        --print("Player n�o encontrado!")
        return false
    end

    local tabela = getPlayerAutoLootList(playerId)
    for i = 1, #tabela do
        local table_itemname = items_avaiables[tabela[i]]
        if not table_itemname then
            print("[AUTO LOOT ERROR] - The item with name: " .. tabela[i] .. " not found in table.")
            return false
        end

        local item_id = table_itemname.id -- id do item
        doSendPlayerExtendedOpcode(playerId, autoloot_send_items_added_opcode, getItemInfo(item_id).clientId.."@"..tabela[i].."@")
    end
    return true
end

-- Adicionar o item na lista do auto loot
function onAddItemAutoLootList(playerId, item_name)
    if not isPlayer(playerId) then
        --print("Player n�o encontrado!")
        return false
    end

    local tabela = getPlayerAutoLootList(playerId)
    if isInArray(tabela, item_name) then
        doPlayerSendTextMessage(playerId, 22, "[AUTO LOOT] - Voc� j� tem o item: " .. item_name .. " na sua lista de auto loot.")
    else
        doPlayerSendTextMessage(playerId, 25, "[AUTO LOOT] - Voc� adicionou o item: " .. item_name .. " na sua lista de auto loot.")
        doPlayerAddAutoLootItem(playerId, item_name) -- Source Function Add in List
        --onReceiveItemsAdded(playerId) -- send to the client items added (removed !!)

        -- Added (V2.0) - not use the default function of the login: onReceiveItemsAdded
        local table_itemname = items_avaiables[item_name]
        if not table_itemname then
            print("[AUTO LOOT ERROR] - The item with name: " .. item_name .. " not found in table.")
            return false
        end

        local item_id = table_itemname.id -- id do item
        doSendPlayerExtendedOpcode(playerId, autoloot_send_items_added_opcode, getItemInfo(item_id).clientId.."@"..item_name.."@")
    end
    return true
end

-- Remover o item da lista do auto loto
function onRemoveItemAutoLootList(playerId, item_name)
    if not isPlayer(playerId) then
        --print("Player n�o encontrado!")
        return false
    end

    local tabela = getPlayerAutoLootList(playerId)
    if isInArray(tabela, item_name) then
        doPlayerSendTextMessage(playerId, 25, "[AUTO LOOT] - Voc� removeu o item: " .. item_name .. " da sua lista de auto loot.")
        doPlayerRemoveAutoLootItem(playerId, item_name) -- Source Function Remove of List

        doSendPlayerExtendedOpcode(playerId, autoloot_send_destroyCHILD_opcode, "destroyAddedItem".."@")
        onReceiveItemsAdded(playerId) -- send to the client items added (removed !!)
    else
        doPlayerSendTextMessage(playerId, 22, "[AUTO LOOT] - Voc� n�o tem o item: " .. item_name .. " na sua lista de auto loot.")
    end
    return true
end

-- Mudar o status do auto loot (ligado ou desligado)
function onAutoLootChangeStatus(playerId, status)
    if not isPlayer(playerId) then
        --print("Player n�o encontrado!")
        return false
    end

    if status == "ligar" then
        doPlayerSendTextMessage(playerId, 25, "[AUTO LOOT] - Voc� ligou o seu auto loot!")
        doPlayerEnabledAutoLoot(playerId, 1)
    else if status == "desligar" then
        doPlayerSendTextMessage(playerId, 22, "[AUTO LOOT] - Voc� desligou o seu auto loot!")
        doPlayerEnabledAutoLoot(playerId, 0)
        end
    end
    return true
end
