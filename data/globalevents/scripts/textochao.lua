local config = {
    positions = {
        ["OutlandSul"] = { x = 1026, y = 1074, z = 13 },   
        ["OutlandNorte"] = { x = 1022, y = 1074, z = 13 }, 
        ["OutlandLeste"] = { x = 1030, y = 1074, z = 13 },
        ["Outlands"] = { x = 1026, y = 1068, z = 13 }, 

        ["BoostMachines"] = { x = 1043, y = 1045, z = 5 },
        ["Coliseum"] = { x = 1032, y = 1057, z = 13 },

        ["Sala de Eventos"] = { x = 1044, y = 1047, z = 5 },
		["AREA VIP"] = { x = 1053, y = 1044, z = 5 },

        ["Teleportes"] = { x = 959, y = 1066, z = 13 },
        ["Templo"] = { x = 950, y = 773, z = 15 },
        ["Box 6"] = { x = 954, y = 773, z = 15 },
        ["Saffron"] = { x = 942, y = 719, z = 15 },
        ["Box 7"] = { x = 946, y = 719, z = 15 },
        ["Box 8"] = { x = 990, y = 705, z = 15 },
        ["Sem Volta"] = { x = 986, y = 705, z = 15 },
        ["Box 9"] = { x = 1077, y = 703, z = 15 },
        ["Box 10"] = { x = 1167, y = 703, z = 15 },
        ["Box 11"] = { x = 1257, y = 703, z = 15 },
        ["Box 12"] = { x = 1302, y = 703, z = 15 },
        ["Box 13"] = { x = 1347, y = 702, z = 15 },
        ["Box 14"] = { x = 1332, y = 747, z = 15 },
        ["Box 15"] = { x = 1302, y = 747, z = 15 },
    }
}

function onThink(cid, interval, lastExecution)
    for text, pos in pairs(config.positions) do
        doSendAnimatedText(pos, text, math.random(1, 255))
    end
    
    return TRUE
end  