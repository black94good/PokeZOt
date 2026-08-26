-- START Wild Pokemon Random Level System
function getRandomWildPokemonLevel(name)
	local pokemonInfo = pokes[name]
	if not pokemonInfo then return 1 end

	local configuredRange = wildPokemonLevelRanges and wildPokemonLevelRanges[name] or nil
	local configuredLevel = configuredRange or pokemonInfo.wildLvl or pokemonInfo.level or 1
	local minimumLevel
	local maximumLevel

	if type(configuredLevel) == "table" then
		minimumLevel = tonumber(configuredLevel.min or configuredLevel[1]) or 1
		maximumLevel = tonumber(configuredLevel.max or configuredLevel[2]) or minimumLevel
	else
		maximumLevel = tonumber(configuredLevel) or 1
		minimumLevel = maximumLevel - (tonumber(wildPokemonDefaultLevelVariation) or 0)
	end

	local levelLimit = pokemonMaxLevel or 100
	minimumLevel = math.max(1, math.min(levelLimit, math.floor(minimumLevel)))
	maximumLevel = math.max(1, math.min(levelLimit, math.floor(maximumLevel)))
	if minimumLevel > maximumLevel then
		minimumLevel, maximumLevel = maximumLevel, minimumLevel
	end

	return math.random(minimumLevel, maximumLevel)
end

function adjustWildPoke(cid, optionalLevel)
if isMonster(cid) and pokes[getCreatureName(cid)] then
	local pokemonName = getCreatureName(cid)
	local levelLimit = pokemonMaxLevel or 100
	local level = optionalLevel and tonumber(optionalLevel) or getRandomWildPokemonLevel(pokemonName)
	level = math.max(1, math.min(levelLimit, math.floor(level or 1)))
-- END Wild Pokemon Random Level System
	
	setPlayerStorageValue(cid, 1000, level) --alterado v1.8
    setPlayerStorageValue(cid, 1001, pokes[getCreatureName(cid)].offense * level)
	setPlayerStorageValue(cid, 1002, pokes[getCreatureName(cid)].defense)
	setPlayerStorageValue(cid, 1003, pokes[getCreatureName(cid)].agility)                                  
	setPlayerStorageValue(cid, 1004, pokes[getCreatureName(cid)].vitality * level)
	setPlayerStorageValue(cid, 1005, pokes[getCreatureName(cid)].specialattack * level)
	
    doRegainSpeed(cid)	     --alterado!
    setCreatureMaxHealth(cid, (getVitality(cid) * HPperVITwild)) 
    doCreatureAddHealth(cid,  getCreatureMaxHealth(cid))

	-- START Pokemon Level and Gender System
	local displayName = getCreatureName(cid)
	if string.find(displayName, "Shiny") then
		displayName = displayName:match("Shiny (.*)") or displayName
	end
	doCreatureSetNick(cid, formatPokemonDisplayName(displayName, level))
	-- END Pokemon Level and Gender System
   
    if pokes[getCreatureName(cid)].exp then
       local exp = pokes[getCreatureName(cid)].exp * baseExpRate + pokes[getCreatureName(cid)].vitality * pokemonExpPerLevelRate
       setPlayerStorageValue(cid, 1006, (exp * generalExpRate/2)*10)
       if getPlayerStorageValue(cid, 22546) == 1 then
          setPlayerStorageValue(cid, 1006, 750)
          doSetCreatureDropLoot(cid, false)      
       end   
	end
end
end       

function getPokemonXMLOutfit(name)                --alterado v1.9 \/
local path = "data/monster/pokemon/Shiny/"..name..".xml"
local tpw = io.type(io.open(path))

if not tpw then
   path = "data/monster/pokemon/geracao 2/"..name..".xml"
   tpw = io.type(io.open(path))
end
if not tpw then
   path = "data/monster/pokemon/geracao 1/"..name..".xml"
   tpw = io.type(io.open(path))
end
if not tpw then
   path = "data/monster/pokemon/"..name..".xml"
   tpw = io.type(io.open(path))
end   
if not tpw then
   return print("[getPokemonXMLOutfit] Poke with name: "..name.." ins't in any paste on monster/pokemon/") and 2
end
   local arq = io.open(path, "a+")
   local txt = arq:read("*all")
   arq:close()
   local a, b = txt:find('look type="(.-)"')
   txt = string.sub(txt, a + 11, b - 1)
return tonumber(txt)
end 

function doEvolutionOutfit(cid, oldout, outfit)
	if not isCreature(cid) then return true end
		if getCreatureOutfit(cid).lookType == oldout then
			doSetCreatureOutfit(cid, {lookType = outfit}, -1)
		else
			doSetCreatureOutfit(cid, {lookType = oldout}, -1)
		end
end

function doSendEvolutionEffect(cid, pos, evolution, turn, ssj, evolve, f, h)
	if not isCreature(cid) then
		doSendAnimatedText(pos, "CANCEL", 215)
	    return true 
    end
	if evolve then
		doEvolvePokemon(getCreatureMaster(cid), {uid = cid}, evolution, 0, 0)
	return true
	end
	doSendMagicEffect(pos, 18)
		if ssj then
			sendSSJEffect(evo)
		end
	doEvolutionOutfit(cid, f, h)
	addEvent(doSendEvolutionEffect, math.pow(1900, turn/20), cid, getThingPos(cid), evolution, turn - 1, turn == 19, turn == 2, f, h)
end

function sendSSJEffect(cid)
	if not isCreature(cid) then return true end
	local pos1 = getThingPos(cid)
	local pos2 = getThingPos(cid)
	pos2.x = pos2.x + math.random(-1, 1)
	pos2.y = pos2.y - math.random(1, 2)
	doSendDistanceShoot(pos1, pos2, 37)
	addEvent(sendSSJEffect, 45, cid)
end

function sendFinishEvolutionEffect(cid, alternate)
	if not isCreature(cid) then return true end
	local pos1 = getThingPos(cid)

	if alternate then
		local pos = {
		[1] = {-2, 0},
		[2] = {-1, -1},
		[3] = {0, -2},
		[4] = {1, -1},
		[5] = {2, 0},
		[6] = {1, 1},
		[7] = {0, 2},
		[8] = {-1, 1}}
		for a = 1, 8 do
			local pos2 = getThingPos(cid)
			pos2.x = pos2.x + pos[a][1]
			pos2.y = pos2.y + pos[a][2]
			local pos = getThingPos(cid)
			doSendDistanceShoot(pos2, pos, 37)
			addEvent(doSendDistanceShoot, 300, pos, pos2, 37)
		end
	else
		for a = 0, 3 do
			doSendDistanceShoot(pos1, getPosByDir(pos1, a), 37)
		end
		for a = 4, 7 do
			addEvent(doSendDistanceShoot, 600, pos1, getPosByDir(pos1, a), 37)
		end
	end
end

function doEvolvePokemon(cid, item2, theevo, stone1, stone2)

	if not isCreature(cid) then return true end

	if not pokes[theevo] or not pokes[theevo].offense then
	doReturnPokemon(cid, item2.uid, getPlayerSlotItem(cid, 8), pokeballs[getPokeballType(getPlayerSlotItem(cid, 8).itemid)].effect, false, true)
	return true
	end

	local owner = getCreatureMaster(item2.uid)
	local pokeball = getPlayerSlotItem(cid, 8)
	-- START Pokemon Level and Gender System
	local pokemonLevel = initializePokemonBallProgress(pokeball.uid, getItemAttribute(pokeball.uid, "poke"))
	-- END Pokemon Level and Gender System
	local description = "Contains a "..theevo.."."
	local pct = getCreatureHealth(item2.uid) / getCreatureMaxHealth(item2.uid)

		doItemSetAttribute(pokeball.uid, "hp", pct)

		doItemSetAttribute(pokeball.uid, "poke", theevo)
		-- START Pokemon Level and Gender System
		doItemSetAttribute(pokeball.uid, "pokeLevel", pokemonLevel)
		-- END Pokemon Level and Gender System
		doItemSetAttribute(pokeball.uid, "description", "Contains a "..theevo..".")

		doPlayerSendTextMessage(cid, 27, "Congratulations! Your "..getPokeName(item2.uid).." evolved into a "..theevo.."!")		

		doSendMagicEffect(getThingPos(item2.uid), 18)
		doTransformItem(getPlayerSlotItem(cid, 7).uid, fotos[theevo])
		doSendMagicEffect(getThingPos(cid), 173)

		local oldpos = getThingPos(item2.uid)
		local oldlod = getCreatureLookDir(item2.uid)
		doRemoveCreature(item2.uid)

		doSummonMonster(cid, theevo)
		local pk = getCreatureSummons(cid)[1]

		doTeleportThing(pk, oldpos, false)
		doCreatureSetLookDir(pk, oldlod)

		sendFinishEvolutionEffect(pk, true)
		addEvent(sendFinishEvolutionEffect, 550, pk, true)
		addEvent(sendFinishEvolutionEffect, 1050, pk)
		
		doPlayerRemoveItem(cid, stone1, 1)
		doPlayerRemoveItem(cid, stone2, 1)

		doAddPokemonInOwnList(cid, theevo)

		local happy = getItemAttribute(pokeball.uid, "happy")

		doItemSetAttribute(pokeball.uid, "happy", happy + happyGainedOnEvolution)

		if happy + happyGainedOnEvolution > 255 then
			doItemSetAttribute(pokeball.uid, "happy", 255)
		end

		adjustStatus(pk, pokeball.uid, true, false)

		if useKpdoDlls then
			doUpdateMoves(cid)
		end
end

function doMathDecimal(number, casas)

	if math.floor(number) == number then return number end

	local c = casas and casas + 1 or 3

	for a = 0, 10 do
		if math.floor(number) < math.pow(10, a) then
			local str = string.sub(""..number.."", 1, a + c)
			return tonumber(str)	
		end
	end

return number
end

function doAdjustWithDelay(cid, pk, health, vit, status)
if isCreature(cid) then                                   
   adjustStatus(pk, getPlayerSlotItem(cid, 8).uid, health, vir, status)
end
end

function adjustStatus(pk, item, health, vite, conditions)

	if not isCreature(pk) then return true end

	-- START Pokemon Level and Gender System
	local gender = normalizePokemonGender(getItemAttribute(item, "gender"))
	doItemSetAttribute(item, "gender", gender)
	addEvent(doCreatureSetSkullType, 10, pk, gender)
	-- END Pokemon Level and Gender System

	-- START Pokemon Level and Gender System
	local pokemonLevel = initializePokemonBallProgress(item, getCreatureName(pk))
	setPlayerStorageValue(pk, 1000, pokemonLevel)
	-- END Pokemon Level and Gender System

-- Defense -- 
local bonusdef = {}
local Tiers = {
[1] = {bonus = DefBonus1},
[2] = {bonus = DefBonus2},
[3] = {bonus = DefBonus3},
[4] = {bonus = DefBonus4},
[5] = {bonus = DefBonus5},
[6] = {bonus = DefBonus6},
[7] = {bonus = DefBonus7},
}
local Tier = getItemAttribute(item, "heldx")

if Tier and Tier > 0 and Tier < 8 then
bonusdef = Tiers[Tier].bonus
else
bonusdef = 1
end
-- Defense --
-- Boost -- 
local bonusboost = {}
local Tiers2 = {
[36] = {bonus = BoostBonus1},
[37] = {bonus = BoostBonus2},
[38] = {bonus = BoostBonus3},
[39] = {bonus = BoostBonus4},
[40] = {bonus = BoostBonus5},
[41] = {bonus = BoostBonus6},
[42] = {bonus = BoostBonus7},
}
if Tier and Tier > 35 and Tier < 43 then
bonusboost = Tiers2[Tier].bonus
else
bonusboost = 0
end
-- Boost -- 
    if (getItemAttribute(item, "ehditto") == 1) then
setPlayerStorageValue(pk, 1001, (pokes[getCreatureName(pk)].offense * (getMasterLevel(pk) + getPokemonBoost(pk))) * 0.75)
setPlayerStorageValue(pk, 1002, (pokes[getCreatureName(pk)].defense) * 0.75)
setPlayerStorageValue(pk, 1003, pokes[getCreatureName(pk)].agility)
setPlayerStorageValue(pk, 1004, (pokes[getCreatureName(pk)].vitality * (getMasterLevel(pk) + getPokemonBoost(pk))) * 0.75)
setPlayerStorageValue(pk, 1005, (pokes[getCreatureName(pk)].specialattack * (getMasterLevel(pk) + getPokemonBoost(pk))) * 0.75)
else
setPlayerStorageValue(pk, 1001, pokes[getCreatureName(pk)].offense * (getMasterLevel(pk) + getPokemonBoost(pk)))
setPlayerStorageValue(pk, 1002, pokes[getCreatureName(pk)].defense)
setPlayerStorageValue(pk, 1003, pokes[getCreatureName(pk)].agility)
setPlayerStorageValue(pk, 1004, pokes[getCreatureName(pk)].vitality * (getMasterLevel(pk) + getPokemonBoost(pk)))
setPlayerStorageValue(pk, 1005, pokes[getCreatureName(pk)].specialattack * (getMasterLevel(pk) + getPokemonBoost(pk)))
end
	
	if vite == true then
		local pct = getCreatureHealth(pk) / getCreatureMaxHealth(pk)
		local vit = getVitality(pk)
		setCreatureMaxHealth(pk, ( vit * HPperVITsummon ))
		doCreatureAddHealth(pk, pct * vit * HPperVITsummon)
	end
                                                                      
	doRegainSpeed(pk)  

	local nick = getItemAttribute(item, "poke")

    if isGhostPokemon(pk) then
       setPlayerStorageValue(pk, 8981, 1)
       updateGhostWalk(pk)
    end
    	
	if string.find(tostring(nick), "Shiny") then
	   nick = tostring(nick):match("Shiny (.*)")
    end

	if getItemAttribute(item, "nick") then
		nick = getItemAttribute(item, "nick")
	end

	setPlayerStorageValue(pk, 1007, nick)

	-- START Pokemon Level and Gender System
	doCreatureSetNick(pk, formatPokemonDisplayName(nick, pokemonLevel))
	-- END Pokemon Level and Gender System

	if not getItemAttribute(item, "happy") then
		doItemSetAttribute(item, "happy", 120)
	end

	if not getItemAttribute(item, "hunger") then
		doItemSetAttribute(item, "hunger", 5)
	end

	local happy = getItemAttribute(item, "happy")
		if happy < 0 then
			happy = 1
		end
	setPlayerStorageValue(pk, 1008, happy)

	local hunger = getItemAttribute(item, "hunger")
	setPlayerStorageValue(pk, 1009, hunger)

	if health == true then
		local mh = HPperVITsummon * getVitality(pk)
		local rd = 1 - (tonumber(getItemAttribute(item, "hp")))
		setCreatureMaxHealth(pk, mh)                                  
		doCreatureAddHealth(pk, getCreatureMaxHealth(pk))
		doCreatureAddHealth(pk, -(getCreatureMaxHealth(pk) * rd))
	end

	if isSummon(pk) and conditions then
		local burn = getItemAttribute(item, "burn")   
		if burn and burn >= 0 then
		   local ret = {id = pk, cd = burn, check = false, damage = getItemAttribute(item, "burndmg"), cond = "Burn"}
		   addEvent(doCondition2, 3500, ret)
		end

		local poison = getItemAttribute(item, "poison")
		if poison and poison >= 0 then
		   local ret = {id = pk, cd = poison, check = false, damage = getItemAttribute(item, "poisondmg"), cond = "Poison"}
		   addEvent(doCondition2, 1500, ret)
		end

        local confuse = getItemAttribute(item, "confuse")
		if confuse and confuse >= 0 then
		   local ret = {id = pk, cd = confuse, check = false, cond = "Confusion"}
		   addEvent(doCondition2, 1200, ret)                                                
		end

        local sleep = getItemAttribute(item, "sleep")
		if sleep and sleep >= 0 then
		   local ret = {id = pk, cd = sleep, check = false, first = true, cond = "Sleep"}
		   doCondition2(ret)
		end
		
		local miss = getItemAttribute(item, "miss")     
		if miss and miss >= 0 then      
          local ret = {id = pk, cd = miss, eff = getItemAttribute(item, "missEff"), check = false, spell = getItemAttribute(item, "missSpell"), cond = "Miss"}
          doCondition2(ret)
        end
        
        local fear = getItemAttribute(item, "fear")
        if fear and fear >= 0 then
           local ret = {id = pk, cd = fear, check = false, skill = getItemAttribute(item, "fearSkill"), cond = "Fear"}
           doCondition2(ret)
        end
        
        local silence = getItemAttribute(item, "silence")
        if silence and silence >= 0 then      
           local ret = {id = pk, cd = silence, eff = getItemAttribute(item, "silenceEff"), check = false, cond = "Silence"}
           doCondition2(ret)
        end                                     
        
        local stun = getItemAttribute(item, "stun")
        if stun and stun >= 0 then
           local ret = {id = pk, cd = stun, eff = getItemAttribute(item, "stunEff"), check = false, spell = getItemAttribute(item, "stunSpell"), cond = "Stun"}
           doCondition2(ret)
        end 
                                                       
        local paralyze = getItemAttribute(item, "paralyze")
        if paralyze and paralyze >= 0 then
           local ret = {id = pk, cd = paralyze, eff = getItemAttribute(item, "paralyzeEff"), check = false, first = true, cond = "Paralyze"}
           doCondition2(ret)
        end  
                                                     
        local slow = getItemAttribute(item, "slow")
        if slow and slow >= 0 then
           local ret = {id = pk, cd = slow, eff = getItemAttribute(item, "slowEff"), check = false, first = true, cond = "Slow"}
           doCondition2(ret)
        end                                              
        
        local leech = getItemAttribute(item, "leech")
        if leech and leech >= 0 then
           local ret = {id = pk, cd = leech, attacker = 0, check = false, damage = getItemAttribute(item, "leechdmg"), cond = "Leech"}
           doCondition2(ret)
        end                               
        
        for i = 1, 3 do
            local buff = getItemAttribute(item, "Buff"..i)
            if buff and buff >= 0 then
               local ret = {id = pk, cd = buff, eff = getItemAttribute(item, "Buff"..i.."eff"), check = false, 
               buff = getItemAttribute(item, "Buff"..i.."skill"), first = true, attr = "Buff"..i}
               doCondition2(ret)
            end
        end
               
	end
	                                                                      --alterado v1.9
    if getItemAttribute(item, "boost") and getItemAttribute(item, "boost") >= 50 and getItemAttribute(item, "aura") then
       sendAuraEffect(pk, auraSyst[getItemAttribute(item, "aura")])        
    end
    
    if getPlayerStorageValue(getCreatureMaster(pk), 6598754) >= 1 then
        setPlayerStorageValue(pk, 6598754, 1)                               
    elseif getPlayerStorageValue(getCreatureMaster(pk), 6598755) >= 1 then
        setPlayerStorageValue(pk, 6598755, 1)
    end

return true
end

function getOffense(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1001))
end

function getDefense(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1002))
end

function getSpeed(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1003))
end

function getVitality(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1004))
end

function getSpecialAttack(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1005))
end

function getHappiness(cid)
	if not isCreature(cid) then return 0 end
return tonumber(getPlayerStorageValue(cid, 1008))
end

function getSpecialDefense(cid)
	if not isCreature(cid) then return 0 end
return getSpecialAttack(cid) * 0.85 + getDefense(cid) * 0.2      
end

function getPokemonLevel(cid, dex)
-- START Pokemon Level and Gender System
if not isCreature(cid) or not pokes[getCreatureName(cid)] then return 0 end 
    if not dex then                      --alterado v1.9
       if getPlayerStorageValue(cid, 1000) > 0 then  
          return getPlayerStorageValue(cid, 1000)
       elseif ehMonstro(cid) then
          -- START Wild Pokemon Random Level System
          return getRandomWildPokemonLevel(getCreatureName(cid))
          -- END Wild Pokemon Random Level System
       end
    end   
return pokes[getCreatureName(cid)].level
-- END Pokemon Level and Gender System
end

function getPokemonLevelByName(name)
return pokes[name] and pokes[name].level or 0  --alterado v1.9
end

-- START Pokemon Level and Gender System
local function getPokemonBallUid(ball)
	if type(ball) == "table" then return tonumber(ball.uid) or 0 end
	return tonumber(ball) or 0
end

function formatPokemonDisplayName(name, level)
	name = tostring(name or "Pokemon")
	name = name:gsub(" %[Lv%. %d+%]$", "")
	level = math.max(1, math.floor(tonumber(level) or 1))
	return name.." [Lv. "..level.."]"
end

function normalizePokemonGender(gender)
	gender = tonumber(gender) or SEX_GENDERLESS
	if gender == 4 then return SEX_MALE end
	if gender == 3 then return SEX_FEMALE end
	if gender == SEX_MALE or gender == SKULL_MALE then return SEX_MALE end
	if gender == SEX_FEMALE or gender == SKULL_FEMALE then return SEX_FEMALE end
	return SEX_GENDERLESS
end

function initializePokemonBallProgress(ball, pokemonName, requestedLevel, requestedExperience)
	local ballUid = getPokemonBallUid(ball)
	if ballUid <= 0 then return 1, 0 end

	pokemonName = pokemonName or getItemAttribute(ballUid, "poke")
	local pokemonInfo = pokemonName and pokes[pokemonName]
	if not pokemonInfo then return 1, 0 end

	local storedGender = getItemAttribute(ballUid, "gender")
	if storedGender then
		doItemSetAttribute(ballUid, "gender", normalizePokemonGender(storedGender))
	end

	local maxLevel = pokemonMaxLevel or 100
	local minimumLevel = tonumber(pokemonInfo.level) or 1
	local level = tonumber(getItemAttribute(ballUid, "pokeLevel")) or tonumber(requestedLevel) or minimumLevel
	level = math.max(1, math.min(math.floor(level), maxLevel))

	-- Balls antigas que receberam level 1 pelo pbar são recuperadas para o
	-- level inicial da espécie quando ainda não possuem experiência individual.
	local storedExperience = tonumber(getItemAttribute(ballUid, "pokeExp"))
	if not storedExperience and level == 1 and minimumLevel > 1 then
		level = math.min(minimumLevel, maxLevel)
	end

	local experienceTable = getPokemonExperienceTable(pokemonName)
	local levelExperience = tonumber(experienceTable[level]) or 0
	local experience = storedExperience
		or tonumber(requestedExperience)
		or tonumber(getItemAttribute(ballUid, "pokeExperience"))
		or levelExperience
	if experience < levelExperience then experience = levelExperience end

	doItemSetAttribute(ballUid, "pokeLevel", level)
	doItemSetAttribute(ballUid, "pokeExp", experience)
	-- Mantém o atributo antigo sincronizado para scripts e balls já existentes.
	doItemSetAttribute(ballUid, "pokeExperience", experience)
	return level, experience
end

function getBallNewLevel(ball)
	local level = initializePokemonBallProgress(ball)
	return level
end

function getBallExperiencePercent(ball)
	local ballUid = getPokemonBallUid(ball)
	local pokemonName = ballUid > 0 and getItemAttribute(ballUid, "poke") or nil
	if not pokemonName or not pokes[pokemonName] then return 0 end

	local level, experience = initializePokemonBallProgress(ballUid, pokemonName)
	if level >= (pokemonMaxLevel or 100) then return 100 end

	local experienceTable = getPokemonExperienceTable(pokemonName)
	local currentLevelExperience = tonumber(experienceTable[level]) or 0
	local nextLevelExperience = tonumber(experienceTable[level + 1]) or currentLevelExperience
	if nextLevelExperience <= currentLevelExperience then return 100 end

	local percent = math.floor(((experience - currentLevelExperience) * 100) /
		(nextLevelExperience - currentLevelExperience))
	return math.max(0, math.min(percent, 100))
end

-- Compatibilidade com o nome usado pelo trade system desta base.
function getBallExpPercet(ball)
	return getBallExperiencePercent(ball)
end

function addPokemonExperience(cid, amount)
	if not isPlayer(cid) or not amount or amount <= 0 then return false end
	if #getCreatureSummons(cid) < 1 then return false end

	local ball = getPlayerSlotItem(cid, CONST_SLOT_FEET)
	if ball.uid <= 0 or not isPokeball(ball.itemid) then return false end

	local pokemonName = getItemAttribute(ball.uid, "poke")
	if not pokemonName or not pokes[pokemonName] then return false end

	local maxLevel = pokemonMaxLevel or 100
	local level, experience = initializePokemonBallProgress(ball.uid, pokemonName)
	if level >= maxLevel then return true end

	local experienceTable = getPokemonExperienceTable(pokemonName)
	experience = experience + math.floor(amount * (pokemonExperienceRate or 1))

	local oldLevel = level
	while level < maxLevel and experience >= (experienceTable[level + 1] or math.huge) do
		level = level + 1
	end

	if level >= maxLevel then
		experience = math.min(experience, experienceTable[maxLevel] or experience)
	end
	doItemSetAttribute(ball.uid, "pokeExp", experience)
	doItemSetAttribute(ball.uid, "pokeExperience", experience)
	doItemSetAttribute(ball.uid, "pokeLevel", level)

	if level > oldLevel then
		local summons = getCreatureSummons(cid)
		if #summons >= 1 and isCreature(summons[1]) then
			adjustStatus(summons[1], ball.uid, true, true, false)
			doSendMagicEffect(getThingPos(summons[1]), 132)
		end
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE,
			"Seu "..pokemonName.." avançou do level "..oldLevel.." para o level "..level..".")
		if useKpdoDlls then doUpdateMoves(cid) end
	end

	return true
end
-- END Pokemon Level and Gender System

function getMasterLevel(poke)
    if not isSummon(poke) then return 0 end
	-- START Pokemon Level and Gender System
	local pokemonLevel = tonumber(getPlayerStorageValue(poke, 1000))
	if pokemonLevel and pokemonLevel > 0 then return pokemonLevel end
	-- END Pokemon Level and Gender System
return getPlayerLevel(getCreatureMaster(poke))
end

function getPokemonBoost(poke)
    if not isSummon(poke) then return 0 end
return getItemAttribute(getPlayerSlotItem(getCreatureMaster(poke), 8).uid, "boost") or 0
end

function getPokeballBoost(ball)
    if not isPokeball(ball.itemid) then return 0 end  --alterado v1.8
return getItemAttribute(ball.uid, "boost") or 0
end

function getPokeName(cid)
	if not isSummon(cid) then return getCreatureName(cid) end
	if getCreatureName(cid) == "Evolution" then return getPlayerStorageValue(cid, 1007) end
	
local item = getPlayerSlotItem(getCreatureMaster(cid), 8)
	if getItemAttribute(item.uid, "nick") then
	   return getItemAttribute(item.uid, "nick")
	end
	if string.find(tostring(getCreatureName(cid)), "Shiny") then
      local newName = tostring(getCreatureName(cid)):match("Shiny (.*)")
      return newName
    end
return getCreatureName(cid)
end

function getPokeballName(item, truename)
if not truename and getItemAttribute(item, "nick") then
return getItemAttribute(item, "nick")
end
return getItemAttribute(item, "poke")
end

function getPokemonName(cid)
return getCreatureName(cid)
end

function getPokemonGender(cid) --alterado v1.9
return getCreatureSkullType(cid)
end

function setPokemonGender(cid, gender)
if isCreature(cid) and gender then        --alterado v1.8
   -- START Pokemon Level and Gender System
   doCreatureSetSkullType(cid, normalizePokemonGender(gender))
   -- END Pokemon Level and Gender System
   return true
end
return false
end

function getWildPokemonExp(cid)
return getPlayerStorageValue(cid, 1006)
end
