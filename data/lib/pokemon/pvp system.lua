-- START Pokemon PvP System
pokemonPvpStorages = {
	dailyPeriod = 985100,
	dailyFrags = 985101,
	weeklyPeriod = 985102,
	weeklyFrags = 985103,
	monthlyPeriod = 985104,
	monthlyFrags = 985105,
	lastAttack = 985106,
	aggressorUntil = 985107
}

local pokemonPvpWhiteSkullEvents = {}

local function getPositiveStorageValue(cid, storage)
	local value = tonumber(getPlayerStorageValue(cid, storage)) or 0
	return value > 0 and value or 0
end

local function getPokemonPvpPeriodKeys()
	return tonumber(os.date("%Y%j")), tonumber(os.date("%Y%W")), tonumber(os.date("%Y%m"))
end

local function refreshPokemonPvpFragPeriod(cid, periodStorage, fragStorage, currentPeriod)
	if tonumber(getPlayerStorageValue(cid, periodStorage)) ~= currentPeriod then
		setPlayerStorageValue(cid, periodStorage, currentPeriod)
		setPlayerStorageValue(cid, fragStorage, 0)
	end
	return getPositiveStorageValue(cid, fragStorage)
end

function getPokemonPvpFragCounts(cid)
	if not isPlayer(cid) then return {daily = 0, weekly = 0, monthly = 0} end

	local dailyPeriod, weeklyPeriod, monthlyPeriod = getPokemonPvpPeriodKeys()
	return {
		daily = refreshPokemonPvpFragPeriod(cid, pokemonPvpStorages.dailyPeriod, pokemonPvpStorages.dailyFrags, dailyPeriod),
		weekly = refreshPokemonPvpFragPeriod(cid, pokemonPvpStorages.weeklyPeriod, pokemonPvpStorages.weeklyFrags, weeklyPeriod),
		monthly = refreshPokemonPvpFragPeriod(cid, pokemonPvpStorages.monthlyPeriod, pokemonPvpStorages.monthlyFrags, monthlyPeriod)
	}
end

local function reachedPokemonPvpFragLimit(frags, prefix)
	local daily = tonumber(getConfigValue("pokemonPvpDailyFragsTo"..prefix)) or 0
	local weekly = tonumber(getConfigValue("pokemonPvpWeeklyFragsTo"..prefix)) or 0
	local monthly = tonumber(getConfigValue("pokemonPvpMonthlyFragsTo"..prefix)) or 0
	return (daily > 0 and frags.daily >= daily)
		or (weekly > 0 and frags.weekly >= weekly)
		or (monthly > 0 and frags.monthly >= monthly)
end

function getPokemonPvpPkName(cid)
	local skull = isPlayer(cid) and getCreatureSkullType(cid) or SKULL_NONE
	if skull == SKULL_BLACK then return "Black PK" end
	if skull == SKULL_RED then return "Red PK" end
	if skull == SKULL_WHITE then return "White PK" end
	if isPlayer(cid) and getPositiveStorageValue(cid, pokemonPvpStorages.aggressorUntil) > os.time() then return "White PK" end
	return "Sem PK"
end

function getPokemonPvpExperienceLossPercent(cid)
	local skull = isPlayer(cid) and getCreatureSkullType(cid) or SKULL_NONE
	if skull == SKULL_BLACK then
		return tonumber(getConfigValue("pokemonPvpBlackExpLossPercent")) or 20
	elseif skull == SKULL_RED then
		return tonumber(getConfigValue("pokemonPvpRedExpLossPercent")) or 10
	elseif skull == SKULL_WHITE then
		return tonumber(getConfigValue("pokemonPvpWhiteExpLossPercent")) or 5
	end
	if isPlayer(cid) and getPositiveStorageValue(cid, pokemonPvpStorages.aggressorUntil) > os.time() then
		return tonumber(getConfigValue("pokemonPvpWhiteExpLossPercent")) or 5
	end
	return 0
end

local function updatePokemonPvpSkull(cid, frags)
	if reachedPokemonPvpFragLimit(frags, "Black") then
		local duration = tonumber(getConfigValue("blackSkullLength")) or (45 * 24 * 60 * 60)
		doPlayerSetSkullEnd(cid, os.time() + duration, SKULL_BLACK)
		return SKULL_BLACK
	elseif reachedPokemonPvpFragLimit(frags, "Red") then
		local duration = tonumber(getConfigValue("redSkullLength")) or (30 * 24 * 60 * 60)
		doPlayerSetSkullEnd(cid, os.time() + duration, SKULL_RED)
		return SKULL_RED
	end
	return getCreatureSkullType(cid)
end

function addPokemonPvpFrag(cid)
	if not isPlayer(cid) then return false end
	local frags = getPokemonPvpFragCounts(cid)
	frags.daily = frags.daily + 1
	frags.weekly = frags.weekly + 1
	frags.monthly = frags.monthly + 1
	setPlayerStorageValue(cid, pokemonPvpStorages.dailyFrags, frags.daily)
	setPlayerStorageValue(cid, pokemonPvpStorages.weeklyFrags, frags.weekly)
	setPlayerStorageValue(cid, pokemonPvpStorages.monthlyFrags, frags.monthly)

	updatePokemonPvpSkull(cid, frags)
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE,
		"Pokemon PvP frag registrado. Hoje: "..frags.daily..", semana: "..frags.weekly..", mes: "..frags.monthly..". Nivel PK: "..getPokemonPvpPkName(cid)..".")
	return true
end

local function getPokemonPvpPlayer(creature)
	if not isCreature(creature) then return 0 end
	if isPlayer(creature) then return creature end
	if isSummon(creature) then
		local master = getCreatureMaster(creature)
		if isPlayer(master) then return master end
	end
	return 0
end

local function clearPokemonPvpWhiteSkull(cid)
	pokemonPvpWhiteSkullEvents[cid] = nil
	if not isPlayer(cid) then return true end

	local aggressorUntil = getPositiveStorageValue(cid, pokemonPvpStorages.aggressorUntil)
	local remaining = aggressorUntil - os.time()
	if remaining > 0 then
		pokemonPvpWhiteSkullEvents[cid] = addEvent(clearPokemonPvpWhiteSkull, (remaining * 1000) + 100, cid)
		return true
	end

	if getCreatureSkullType(cid) == SKULL_WHITE then
		doPlayerSetSkullEnd(cid, 0, SKULL_WHITE)
	end
	return true
end

local function openOrRefreshPokemonPvpWhiteSkull(cid)
	local duration = tonumber(getConfigValue("pokemonPvpWhiteSkullTime")) or (10 * 60)
	local aggressorUntil = os.time() + duration
	setPlayerStorageValue(cid, pokemonPvpStorages.aggressorUntil, aggressorUntil)

	local skull = getCreatureSkullType(cid)
	if skull == SKULL_NONE or skull == SKULL_WHITE then
		doPlayerSetSkullEnd(cid, aggressorUntil, SKULL_WHITE)
		if pokemonPvpWhiteSkullEvents[cid] then
			stopEvent(pokemonPvpWhiteSkullEvents[cid])
		end
		pokemonPvpWhiteSkullEvents[cid] = addEvent(clearPokemonPvpWhiteSkull, (duration * 1000) + 100, cid)
	end
end

function isPokemonPvpAggressor(cid)
	if not isPlayer(cid) then return false end
	if getPositiveStorageValue(cid, pokemonPvpStorages.aggressorUntil) > os.time() then return true end
	return isInArray({SKULL_WHITE, SKULL_RED, SKULL_BLACK}, getCreatureSkullType(cid))
end

function markPokemonPvpAttack(attacker, target)
	local attackerPlayer = getPokemonPvpPlayer(attacker)
	local targetPlayer = getPokemonPvpPlayer(target)
	if attackerPlayer == 0 or targetPlayer == 0 or attackerPlayer == targetPlayer then return false end
	setPlayerStorageValue(attackerPlayer, pokemonPvpStorages.lastAttack, os.time())

	-- Atacar um jogador inocente abre/renova PK. Revidar contra um PK nao
	-- transforma o defensor em agressor.
	local attackerIsAggressor = isPokemonPvpAggressor(attackerPlayer)
	local targetIsAggressor = isPokemonPvpAggressor(targetPlayer)
	if not targetIsAggressor or (attackerIsAggressor and getCreatureSkullType(attackerPlayer) == SKULL_WHITE) then
		openOrRefreshPokemonPvpWhiteSkull(attackerPlayer)
	end
	return true
end

function getPokemonPvpReturnWait(cid)
	if not isPlayer(cid) then return 0 end
	local lastAttack = getPositiveStorageValue(cid, pokemonPvpStorages.lastAttack)
	if lastAttack <= 0 then return 0 end
	local delay = tonumber(getConfigValue("pokemonPvpReturnDelay")) or 10
	return math.max(0, delay - (os.time() - lastAttack))
end

function getPokemonPvpWhiteSkullWait(cid)
	if not isPlayer(cid) or getCreatureSkullType(cid) ~= SKULL_WHITE then return 0 end
	local aggressorUntil = getPositiveStorageValue(cid, pokemonPvpStorages.aggressorUntil)
	return math.max(0, aggressorUntil - os.time())
end

function canReturnPokemonAfterPvp(cid)
	local remaining = getPokemonPvpReturnWait(cid)
	return remaining <= 0, remaining
end

local function getPokemonPvpKillerOwner(deathList, victimOwner)
	if type(deathList) ~= "table" then return 0 end
	for _, killer in ipairs(deathList) do
		local killerOwner = getPokemonPvpPlayer(killer)
		if killerOwner ~= 0 and killerOwner ~= victimOwner then
			return killerOwner
		end
	end
	return 0
end

function removePokemonPvpExperience(ball, percent)
	local ballUid = type(ball) == "table" and ball.uid or tonumber(ball)
	percent = math.max(0, math.min(100, tonumber(percent) or 0))
	if not ballUid or ballUid <= 0 or percent <= 0 then return 0, 0, 0, 0, 0 end

	local pokemonName = getItemAttribute(ballUid, "poke")
	if not pokemonName or not pokes[pokemonName] then return 0, 0, 0, 0, 0 end
	local oldLevel, oldExperience = initializePokemonBallProgress(ballUid, pokemonName)
	local experienceTable = getPokemonExperienceTable(pokemonName)
	local minimumExperience = tonumber(experienceTable[1]) or 0
	local lostExperience = math.floor(oldExperience * percent / 100)
	local newExperience = math.max(minimumExperience, oldExperience - lostExperience)
	local newLevel = 1
	local maxLevel = pokemonMaxLevel or 100
	while newLevel < maxLevel and newExperience >= (tonumber(experienceTable[newLevel + 1]) or math.huge) do
		newLevel = newLevel + 1
	end

	doItemSetAttribute(ballUid, "pokeExp", newExperience)
	doItemSetAttribute(ballUid, "pokeExperience", newExperience)
	doItemSetAttribute(ballUid, "pokeLevel", newLevel)
	return lostExperience, oldLevel, newLevel, oldExperience, newExperience
end

function handlePokemonPvpDeath(victimOwner, pokemon, deathList, ball)
	if not isPlayer(victimOwner) then return false end
	local victimSkull = getCreatureSkullType(victimOwner)
	local killerOwner = getPokemonPvpKillerOwner(deathList, victimOwner)
	local victimWasAggressor = isPokemonPvpAggressor(victimOwner)

	if victimWasAggressor then
		local percent = getPokemonPvpExperienceLossPercent(victimOwner)
		local lostExperience, oldLevel, newLevel = removePokemonPvpExperience(ball, percent)
		if lostExperience > 0 then
			doPlayerSendTextMessage(victimOwner, MESSAGE_STATUS_CONSOLE_ORANGE,
				"Seu Pokemon perdeu "..lostExperience.." de experiencia ("..percent.."%) por morrer como "..getPokemonPvpPkName(victimOwner)..". Level: "..oldLevel.." -> "..newLevel..".")
		end
	end

	if killerOwner ~= 0 then
		local pokemonName = getItemAttribute(type(ball) == "table" and ball.uid or ball, "poke") or getCreatureName(pokemon)
		doPlayerSendTextMessage(killerOwner, MESSAGE_STATUS_WARNING,
			"Jogador "..getCreatureName(killerOwner).." matou "..pokemonName.." do jogador "..getCreatureName(victimOwner)..".")

		-- START Pokemon PvP Frag Fix
		-- Uma morte injustificada sempre abre/renova o PK e conta o frag,
		-- mesmo que algum golpe antigo nao tenha passado pelo evento de ataque.
		if not victimWasAggressor then
			openOrRefreshPokemonPvpWhiteSkull(killerOwner)
			addPokemonPvpFrag(killerOwner)
		end
		-- END Pokemon PvP Frag Fix
	end
	return true
end
-- END Pokemon PvP System
