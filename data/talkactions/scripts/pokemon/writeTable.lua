-- START Wild Pokemon Level Range Table System
function onSay(cid, words, param, channel)

local str = "pokes = {"
local file = io.open('data/pokemon/writeTable.txt', 'w')
if (not file) then
   sendMsgToPlayer(cid, 20, "File: data/pokemon/writeTable.txt, not found...")
   return true
end
for i, table in ipairs(oldpokedex) do
    local t = pokes[table[1]]
    if not t or not t.offense then
       return sendMsgToPlayer(cid, 20, "Error has occored... Poke: "..table[1].." isn't in the table pokes or don't have the 'attribute' offense!")
    end
    local maximumWildLevel
    local minimumWildLevel
    if type(t.wildLvl) == "table" then
       minimumWildLevel = tonumber(t.wildLvl.min or t.wildLvl[1]) or 1
       maximumWildLevel = tonumber(t.wildLvl.max or t.wildLvl[2]) or minimumWildLevel
    else
       maximumWildLevel = math.min(pokemonMaxLevel or 100, tonumber(t.wildLvl or t.level) or 1)
       minimumWildLevel = math.max(1, maximumWildLevel - (wildPokemonDefaultLevelVariation or 5))
    end
    str = str.. '\n\n["'..table[1]..'"] = {offense = '..t.offense..', defense = '..t.defense..', specialattack = '..t.specialattack..', vitality = '..t.vitality..', agility = '..t.agility..', exp = '..t.exp..', level = '..t.level..', wildLvl = {min = '..minimumWildLevel..', max = '..maximumWildLevel..'}, type = "'..t.type..'", type2 = "'..t.type2..'"},'
end
str = str.."\n}"
file:write(str)
file:close()
sendMsgToPlayer(cid, 20, "Table added in file 'data/pokemon/writeTable.txt'...")
return true
end
-- END Wild Pokemon Level Range Table System
