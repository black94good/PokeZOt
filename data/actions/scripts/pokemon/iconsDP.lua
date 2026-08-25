-- START Ball System
function onUse(cid, item, frompos, item2, topos)
	if getPlayerStorageValue(cid, 8955) < 1 then return true end

	local locker = getTileItemById(frompos, item.itemid).uid
	if locker <= 0 or not isContainer(locker) then return true end

	local balls = getPokeballsInContainer(locker)
	for _, ball in pairs(balls) do
		local pokemon = getItemAttribute(ball, "poke")
		if pokemon then
			local state = getItemAttribute(ball, "morta") == "yes" and "off" or "on"
			setPhysicalPokemonBall(ball, pokemon, nil, state)
		end
	end

	return true
end
-- END Ball System
