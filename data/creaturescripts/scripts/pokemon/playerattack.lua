-- START Pokemon PvP System
local fightcondition = createConditionObject(CONDITION_INFIGHT)
setConditionParam(fightcondition, CONDITION_PARAM_TICKS, tonumber(getConfigValue("pzLocked")) or 60 * 1000)

function fightCondic(cid)
	if not isCreature(cid) then return true end
	if not isCreature(getCreatureTarget(cid)) then return true end
	doAddCondition(cid, fightcondition)
addEvent(fightCondic, 1000, cid)
end

function onTarget(cid, target)

local levelAllowed, attackerLevel, targetLevel = canPokemonPvpByLevel(cid, target)
if not levelAllowed then
   local maximumDifference = tonumber(getConfigValue("pokemonPvpMaxLevelDifference")) or 10
   doPlayerSendCancel(cid, "A diferenca maxima permitida entre os Pokemon e de "..maximumDifference.." levels. Seu Pokemon: "..attackerLevel..", alvo: "..targetLevel..".")
   return false
end

if isPlayer(target) then
   if canAttackOther(cid, target) == "Cant" then            
      return false 
   elseif isPlayer(target) and #getCreatureSummons(target) >= 1 and canAttackOther(cid, target) == "Can" then
      return false
   end
end

if getPlayerStorageValue(target, 201) ~= -1 then
for a, b in pairs(ginasios) do
if getPlayerStorageValue(target, ginasios[getPlayerStorageValue(target, 201)].storage) == 1 then
	if getPlayerStorageValue(cid, ginasios[getPlayerStorageValue(target, 201)].storage) ~= 1 then
	doPlayerSendCancel(cid, "You can't attack this pokemon.")
	return false
	end
end
end
end

if isSummon(target) then
	local targetOwner = getCreatureMaster(target)
	local targetSkull = isPlayer(targetOwner) and getCreatureSkullType(targetOwner) or SKULL_NONE
	local targetIsPk = isInArray({SKULL_WHITE, SKULL_RED, SKULL_BLACK}, targetSkull)

	if isPlayer(targetOwner) and
	   (getTileInfo(getThingPos(cid)).protection or
	    getTileInfo(getThingPos(targetOwner)).protection or
	    getTileInfo(getThingPos(target)).protection) then
		doPlayerSendCancel(cid, "Pokemon PvP is not allowed inside a protection zone.")
		return false
	end

	if getConfigValue("pokemonPvpRequireButton") ~= false and
	   isPlayer(targetOwner) and targetOwner ~= cid and not targetIsPk and
	   not isPokemonPvpButtonActive(cid) then
		doPlayerSendCancel(cid, "Activate the PvP button before attacking another player's Pokemon.")
		return false
	end

	if canAttackOther(cid, target) == "Cant" then
	local minLevel = tonumber(getConfigValue("pokemonPvpMinLevel")) or 30
	if getConfigValue("pokemonPvpEnabled") == false then
		doPlayerSendCancel(cid, "Pokemon PvP is disabled on this server.")
	elseif isPlayer(targetOwner) and (getPlayerLevel(cid) < minLevel or getPlayerLevel(targetOwner) < minLevel) then
		doPlayerSendCancel(cid, "Both trainers need level "..minLevel.." to battle.")
	else
		doPlayerSendCancel(cid, "You can't attack this player's Pokemon.")
	end
	return false
	end

	-- START Pokemon PvP Frag System
	markPokemonPvpAttack(cid, target)
	-- END Pokemon PvP Frag System

	if isPlayer(targetOwner) and targetOwner ~= cid then
		doAddCondition(cid, fightcondition)
		doAddCondition(targetOwner, fightcondition)

		if not targetIsPk then
			if getCreatureSkullType(cid) == SKULL_NONE then
				doCreatureSetSkullType(cid, SKULL_WHITE)
			end
			doPlayerSetPzLocked(cid, true)
		end
	end
end

return TRUE
end
-- END Pokemon PvP System
