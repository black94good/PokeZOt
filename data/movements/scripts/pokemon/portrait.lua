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

local function refreshEquippedPokemonPortrait(cid)
	if not isCreature(cid) then return true end

	local equippedBall = getPlayerSlotItem(cid, CONST_SLOT_FEET)
	local pokemon = equippedBall.uid > 0 and getItemAttribute(equippedBall.uid, "poke") or nil
	if pokemon and (getItemAttribute(equippedBall.uid, "Icone") == "yes" or getItemAttribute(equippedBall.uid, "icon") == "yes") then
		local ballState = getItemAttribute(equippedBall.uid, "morta") == "yes" and "dead" or "alive"
		setPhysicalPokemonBall(equippedBall.uid, pokemon, nil, ballState)
	end

	local legsItem = getPlayerSlotItem(cid, CONST_SLOT_LEGS)
	if legsItem.uid <= 0 then return true end

	local portraitId = pokemon and getPokemonPortrait(pokemon) or DEFAULT_POKEMON_PORTRAIT
	if portraitId and legsItem.itemid ~= portraitId then
		doTransformItem(legsItem.uid, portraitId)
	end

	return true
end

function onEquip(cid, item, slot)
	if not cid or item.uid <= 0 then return true end
	if not getItemAttribute(item.uid, "poke") then return true end

	-- O core 0.3.6 ainda esta concluindo a movimentacao do inventario neste
	-- callback. Atualizar o retrato depois evita invalidar ponteiros de slots.
	addEvent(refreshEquippedPokemonPortrait, 20, cid)
	return true
end

function onDeEquip(cid, item, slot)
	if not cid or item.uid <= 0 then return true end
	if not getItemAttribute(item.uid, "poke") then return true end

	addEvent(refreshEquippedPokemonPortrait, 20, cid)
	return true
end
-- END Ball System
