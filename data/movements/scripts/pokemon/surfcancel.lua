-- START Pokemon Transportation System
function onStepIn(cid, item, position, fromPosition)
if not isPlayer(cid) or getPlayerStorageValue(cid, 17000) >= 1 then
return true
end
if getPlayerStorageValue(cid, 63215) >= 1 then
	local ball, ballError = getMountedPokemonBall(cid)
	if not ball then
		doPlayerSendCancel(cid, ballError)
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	local pokemon = getItemAttribute(ball.uid, "poke")
	if not pokemon or not pokes[pokemon] then
		doTeleportThing(cid, fromPosition, false)
		return true
	end

	if getItemAttribute(ball.uid, "nick") then
		doCreatureSay(cid, getItemAttribute(ball.uid, "nick")..", Im tired of surfing!", TALKTYPE_SAY)
	else
		doCreatureSay(cid, pokemon..", Im tired of surfing!", TALKTYPE_SAY)
	end

	doSummonMonster(cid, pokemon)
	local pk = getCreatureSummons(cid)[1]
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
	doChangeSpeed(pk, getCreatureSpeed(cid))
	doChangeSpeed(cid, -getCreatureSpeed(cid))
	doRegainSpeed(cid)
	doTeleportThing(pk, fromPosition, false)
	doTeleportThing(pk, getThingPos(cid), true)
	doCreatureSetLookDir(pk, getCreatureLookDir(cid))
	adjustStatus(pk, ball.uid, true, false, true)
	clearMountedPokemonBall(cid)

return true
end
end
-- END Pokemon Transportation System
