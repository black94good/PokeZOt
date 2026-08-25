-- START Ball System
local DEFAULT_POKEMON_PORTRAIT = 11138

local function getPokemonPortrait(pokemon)
	if fotos[pokemon] then return fotos[pokemon] end

	for name, portraitId in pairs(fotos) do
		if string.lower(pokemon) == string.lower(name) then
			return portraitId
		end
	end

	return nil
end

function onEquip(cid, item, slot)
	if not cid or item.uid <= 0 then return true end

	local pokemon = getItemAttribute(item.uid, "poke")
	if not pokemon then return true end

	if getItemAttribute(item.uid, "Icone") == "yes" or getItemAttribute(item.uid, "icon") == "yes" then
		local ballState = getItemAttribute(item.uid, "morta") == "yes" and "dead" or "alive"
		setPhysicalPokemonBall(item.uid, pokemon, nil, ballState)
	end

	local legsItem = getPlayerSlotItem(cid, CONST_SLOT_LEGS)
	if legsItem.uid <= 0 then return true end

	local portraitId = getPokemonPortrait(pokemon)
	if portraitId then
		doTransformItem(legsItem.uid, portraitId)
	end

	return true
end

function onDeEquip(cid, item, slot)
	if not cid or item.uid <= 0 then return true end
	if not getItemAttribute(item.uid, "poke") then return true end

	local legsItem = getPlayerSlotItem(cid, CONST_SLOT_LEGS)
	if legsItem.uid > 0 then
		doTransformItem(legsItem.uid, DEFAULT_POKEMON_PORTRAIT)
	end

	return true
end
-- END Ball System
