-- START Pokemon Transportation System
local function doSendMagicEffecte(pos, effect)
	addEvent(doSendMagicEffect, 50, pos, effect)
end

local waters = {
	11756, 4614, 4615, 4616, 4617, 4618, 4619,
	4608, 4609, 4610, 4611, 4612, 4613,
	7236, 4620, 4621, 4622, 4623, 4624, 4625,
	4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825
}

local premium = false

function onStepIn(cid, item, position, fromPosition)
	if not isPlayer(cid) or isInArray({5, 6}, getPlayerGroupId(cid)) then
		return true
	end

	if getPlayerStorageValue(cid, 75846) >= 1 then
		return true
	end

	if getCreatureOutfit(cid).lookType == 814 then
		return false
	end

	if not isPremium(cid) and premium == true then
		doTeleportThing(cid, fromPosition, false)
		doPlayerSendCancel(cid, "Only premium members are allowed to surf.")
		return true
	end

	if getCreatureOutfit(cid).lookType == 316 or getCreatureOutfit(cid).lookType == 648 then
		doSendMagicEffect(fromPosition, 136)
	end

	if getPlayerStorageValue(cid, 63215) >= 1 or getPlayerStorageValue(cid, 17000) >= 1 then
		return true
	end

	if getPlayerStorageValue(cid, 5700) >= 1 then
		doPlayerSendCancel(cid, "You can't do that while is mount in a bike!")
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	if getPlayerStorageValue(cid, 212124) >= 1 then
		doPlayerSendCancel(cid, "You can't do it with a pokemon with mind controlled!")
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	if getPlayerStorageValue(cid, 52480) >= 1 then
		doPlayerSendCancel(cid, "You can't do it while a duel!")
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	if getPlayerStorageValue(cid, 6598754) == 1 or getPlayerStorageValue(cid, 6598755) == 1 then
		doPlayerSendCancel(cid, "You can't do it while in the PVP Zone!")
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	local summons = getCreatureSummons(cid)
	if #summons == 0 or not isCreature(summons[1]) then
		doPlayerSendCancel(cid, "You need a pokemon to surf.")
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	local summon = summons[1]
	local pokeName = getPokemonName(summon)
	if not pokeName or not isInArray(specialabilities["surf"], pokeName) then
		doPlayerSendCancel(cid, "This pokemon cannot surf.")
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	if not surfs[pokeName] then
		doPlayerSendCancel(cid, "This pokemon has no surf outfit configured.")
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	local ball = getPlayerSlotItem(cid, 8)
	if not ball or ball.uid <= 0 then
		doPlayerSendCancel(cid, "Put your pokemon ball in the correct slot.")
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	local addon = tonumber(getItemAttribute(ball.uid, "addon") or 0)
	-- START Pokemon Transportation Outfit Colors
	savePokemonTransportBaseOutfit(cid)
	-- END Pokemon Transportation Outfit Colors
	if addon > 0 and surfsAddon[addon] then
		applyPokemonTransportOutfit(cid, surfsAddon[addon][1])
	else
		applyPokemonTransportOutfit(cid, surfs[pokeName].lookType + 351)
	end

	doCreatureSay(cid, "" .. getPokeName(summon) .. ", lets surf!", TALKTYPE_SAY)
	doChangeSpeed(cid, -getCreatureSpeed(cid))

	local speed = 75 + PlayerSpeed + surfs[pokeName].speed * 8 * speedRate
	setPlayerStorageValue(cid, 54844, speed)
	doChangeSpeed(cid, speed)

	local pct = getCreatureHealth(summon) / getCreatureMaxHealth(summon)
	doItemSetAttribute(ball.uid, "hp", pct)
	doRemoveCreature(summon)
	markMountedPokemonBall(cid, pokeName)
	addEvent(setPlayerStorageValue, 100, cid, 63215, 1)

	if getItemAttribute(ball.uid, "boost") and getItemAttribute(ball.uid, "boost") >= 50 and getPlayerStorageValue(cid, 42368) <= 0 then
		local aura = tonumber(getItemAttribute(ball.uid, "aura"))
		if aura and auraSyst[aura] then addEvent(sendAuraEffect, 120, cid, auraSyst[aura]) end
	end

	if useOTClient then
		doPlayerSendCancel(cid, '12//,hide')
	end

	return true
end

local direffects = {30, 49, 9, 51}

function onStepOut(cid, item, position, fromPosition)
	if not isPlayer(cid) then
		return true
	end

	if getCreatureOutfit(cid).lookType == 814 then
		return false
	end

	local checkpos = fromPosition
	checkpos.stackpos = 0

	if isInArray(waters, getTileInfo(checkpos).itemid) then
		if getPlayerStorageValue(cid, 63215) >= 1 or getPlayerStorageValue(cid, 17000) >= 1 then
			doSendMagicEffecte(fromPosition, direffects[getCreatureLookDir(cid) + 1])
		end
	end

	if not isInArray(waters, getTileInfo(getThingPos(cid)).itemid) then
		if getPlayerStorageValue(cid, 17000) >= 1 then
			return true
		end

		if getPlayerStorageValue(cid, 63215) <= 0 then
			return true
		end

		local ball, ballError = getMountedPokemonBall(cid)
		if not ball then
			doPlayerSendCancel(cid, ballError)
			doTeleportThing(cid, fromPosition, false)
			return true
		end

		local pokemon = getItemAttribute(ball.uid, "poke")
		if not pokemon or not pokes[pokemon] then
			return true
		end

		if getItemAttribute(ball.uid, "nick") then
			doCreatureSay(cid, getItemAttribute(ball.uid, "nick") .. ", I'm tired of surfing!", TALKTYPE_SAY)
		else
			doCreatureSay(cid, pokemon .. ", I'm tired of surfing!", TALKTYPE_SAY)
		end

		doSummonMonster(cid, pokemon)
		local pk = getCreatureSummons(cid)[1]
		local pb = ball.uid

		if not isCreature(pk) then
			pk = doCreateMonster(pokemon, fromPosition)
			if not isCreature(pk) then
				doPlayerSendCancel(cid, "You can't stop surfing here.")
				doTeleportThing(cid, fromPosition, false)
				return true
			end
			doConvinceCreature(cid, pk)
		end

		-- O estado montado so e removido depois que o Pokemon foi recriado.
		-- START Pokemon Transportation Outfit Colors
		restorePokemonTransportBaseOutfit(cid, true)
		-- END Pokemon Transportation Outfit Colors
		setPlayerStorageValue(cid, 63215, -1)

		if surfsAddon[getItemAttribute(pb, "addon")] and getItemAttribute(pb, "addon") > 1 then
			doSetCreatureOutfit(pk, {lookType = getItemAttribute(pb, "addon")}, -1)
		end

		doChangeSpeed(pk, getCreatureSpeed(cid))
		doChangeSpeed(cid, -getCreatureSpeed(cid))
		doRegainSpeed(cid)

		doTeleportThing(pk, fromPosition, false)
		doTeleportThing(pk, getThingPos(cid), false)
		doCreatureSetLookDir(pk, getCreatureLookDir(cid))
		adjustStatus(pk, ball.uid, true, false, true)
		clearMountedPokemonBall(cid)

		if useOTClient then
			doPlayerSendCancel(cid, '12//,show')
		end
	end

	return true
end
-- END Pokemon Transportation System
