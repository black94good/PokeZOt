-- START Pokemon Admin Create Ball System
local function trimCreateBallParameter(value)
	local cleanedValue = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
	return cleanedValue
end

local function resolveCreateBallPokemonName(value)
	local requestedName = trimCreateBallParameter(value):lower()
	if requestedName == "" then return nil end

	for pokemonName in pairs(pokes) do
		if pokemonName:lower() == requestedName then
			return pokemonName
		end
	end
	return nil
end

local createBallTypes = {
	["normal"] = "normal",
	["poke"] = "normal",
	["pokeball"] = "normal",
	["poke ball"] = "normal",
	["great"] = "great",
	["greatball"] = "great",
	["great ball"] = "great",
	["super"] = "super",
	["superball"] = "super",
	["super ball"] = "super",
	["ultra"] = "ultra",
	["ultraball"] = "ultra",
	["ultra ball"] = "ultra",
	["safari"] = "saffari",
	["saffari"] = "saffari",
	["safariball"] = "saffari",
	["saffariball"] = "saffari",
	["safari ball"] = "saffari",
	["saffari ball"] = "saffari",
	["dark"] = "dark",
	["darkball"] = "dark",
	["dark ball"] = "dark",
	["shinypoke"] = "shinypoke",
	["shinygreat"] = "shinygreat",
	["shinysuper"] = "shinysuper",
	["shinyultra"] = "shinyultra",
	["shinysaffari"] = "shinysaffari",
	["shinydark"] = "shinydark"
}

local createBallGenders = {
	["male"] = SEX_MALE,
	["macho"] = SEX_MALE,
	["masculino"] = SEX_MALE,
	["m"] = SEX_MALE,
	["1"] = SEX_MALE,
	["female"] = SEX_FEMALE,
	["femea"] = SEX_FEMALE,
	["fêmea"] = SEX_FEMALE,
	["feminino"] = SEX_FEMALE,
	["f"] = SEX_FEMALE,
	["0"] = SEX_FEMALE,
	["genderless"] = SEX_GENDERLESS,
	["sem sexo"] = SEX_GENDERLESS
}

local createBallRandomGenders = {
	["random"] = true,
	["aleatorio"] = true,
	["aleatório"] = true
}

local function sendCreateBallUsage(cid)
	doPlayerSendCancel(cid, "Use: /cb Pokemon, ball, level, boost, sexo")
	doPlayerSendTextMessage(cid, 27, "Exemplo: /cb Pikachu, ultra, 50, 10, macho")
end

function onSay(cid, words, param)
	if trimCreateBallParameter(param) == "" then
		sendCreateBallUsage(cid)
		return true
	end

	local parameters = string.explode(param, ",")
	if #parameters < 5 then
		sendCreateBallUsage(cid)
		return true
	end

	local name = resolveCreateBallPokemonName(parameters[1])
	if not name then
		doPlayerSendCancel(cid, "Pokemon inexistente: "..trimCreateBallParameter(parameters[1])..".")
		return true
	end

	local requestedBall = trimCreateBallParameter(parameters[2]):lower()
	local ballType = createBallTypes[requestedBall]
	if not ballType then
		doPlayerSendCancel(cid, "Ball invalida. Use: normal, great, super, ultra, safari ou dark.")
		return true
	end

	local level = tonumber(trimCreateBallParameter(parameters[3]))
	if not level or level ~= math.floor(level) then
		doPlayerSendCancel(cid, "O level precisa ser um numero inteiro.")
		return true
	end
	level = math.floor(level)
	if level < 1 or level > (pokemonMaxLevel or 100) then
		doPlayerSendCancel(cid, "O level deve ficar entre 1 e "..(pokemonMaxLevel or 100)..".")
		return true
	end

	local boost = tonumber(trimCreateBallParameter(parameters[4]))
	if not boost or boost ~= math.floor(boost) then
		doPlayerSendCancel(cid, "O boost precisa ser um numero inteiro.")
		return true
	end
	boost = math.floor(boost)
	if boost < 0 or boost > 50 then
		doPlayerSendCancel(cid, "O boost deve ficar entre 0 e 50.")
		return true
	end

	local requestedGender = trimCreateBallParameter(parameters[5]):lower()
	local gender = createBallGenders[requestedGender]
	if createBallRandomGenders[requestedGender] then
		gender = getRandomGenderByName(name)
	elseif gender == nil then
		doPlayerSendCancel(cid, "Sexo invalido. Use: macho, femea, random ou genderless.")
		return true
	end

	local physicalBallType = getPhysicalPokemonBallType(ballType, name)
	local ballConfig = pokeballs[physicalBallType]
	if not ballConfig or not ballConfig.alive then
		doPlayerSendCancel(cid, "A ball selecionada nao possui item vivo configurado.")
		return true
	end

	local trainerBag = getPlayerSlotItem(cid, CONST_SLOT_BACKPACK)
	if trainerBag.uid <= 0 or not isContainer(trainerBag.uid) then
		doPlayerSendCancel(cid, "Equipe sua trainer bag antes de criar o Pokemon.")
		return true
	end
	if not canPlayerCarryPokemon(cid, 1) then
		doPlayerSendCancel(cid, "Voce ja possui o limite de seis Pokemon.")
		return true
	end

	-- A ball e criada ja dentro da bag. Isso evita deixar um item virtual
	-- temporariamente nos slots de equipamento durante o comando administrativo.
	local item = addItemInFreeBag(trainerBag.uid, ballConfig.alive, 1)
	if not item then
		doPlayerSendCancel(cid, "Nao ha espaco livre na trainer bag.")
		return true
	end
	doItemSetAttribute(item, "poke", name)
	doItemSetAttribute(item, "hp", 1)
	doItemSetAttribute(item, "happy", 255)
	doItemSetAttribute(item, "gender", normalizePokemonGender(gender))
	if boost > 0 then
		doItemSetAttribute(item, "boost", boost)
	end
	if name == "Shiny Hitmonchan" or name == "Hitmonchan" then
		doItemSetAttribute(item, "hands", 0)
	end

	initializePokemonBallProgress(item, name, level)
	setPokemonBallCaptureInfo(item, cid, name)
	doItemSetAttribute(item, "description", "Contains a "..name..". Level: "..level..". Boost: +"..boost..".")
	doItemSetAttribute(item, "fakedesc", "Contains a "..name..". Level: "..level..". Boost: +"..boost..".")
	setPhysicalPokemonBall(item, name, physicalBallType, "alive")
	addEvent(doUpdatePokemonsBar, 100, cid)

	local genderName = gender == SEX_MALE and "macho" or (gender == SEX_FEMALE and "femea" or "genderless")
	doPlayerSendTextMessage(cid, 27, name.." criado: "..physicalBallType..", level "..level..", boost +"..boost..", "..genderName..".")
	print(name.." ball has been created by "..getPlayerName(cid).." at level "..level.." with boost +"..boost..".")
	return true
end
-- END Pokemon Admin Create Ball System
