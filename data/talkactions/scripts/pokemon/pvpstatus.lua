-- START Pokemon PvP Frag System
function onSay(cid, words, param, channel)
	local frags = getPokemonPvpFragCounts(cid)
	local pkName = getPokemonPvpPkName(cid)
	local lossPercent = getPokemonPvpExperienceLossPercent(cid)
	local returnWait = getPokemonPvpReturnWait(cid)
	local whiteSkullWait = getPokemonPvpWhiteSkullWait(cid)
	local redDaily = tonumber(getConfigValue("pokemonPvpDailyFragsToRed")) or 3
	local redWeekly = tonumber(getConfigValue("pokemonPvpWeeklyFragsToRed")) or 5
	local redMonthly = tonumber(getConfigValue("pokemonPvpMonthlyFragsToRed")) or 10
	local blackDaily = tonumber(getConfigValue("pokemonPvpDailyFragsToBlack")) or 6
	local blackWeekly = tonumber(getConfigValue("pokemonPvpWeeklyFragsToBlack")) or 10
	local blackMonthly = tonumber(getConfigValue("pokemonPvpMonthlyFragsToBlack")) or 20

	local message = "Status Pokemon PvP\n"
	message = message.."PK: "..pkName.." | Perda de EXP ao morrer: "..lossPercent.."%\n"
	message = message.."Frags - hoje: "..frags.daily..", semana: "..frags.weekly..", mes: "..frags.monthly.."\n"
	message = message.."Red PK: "..redDaily.."/dia, "..redWeekly.."/semana, "..redMonthly.."/mes\n"
	message = message.."Black PK: "..blackDaily.."/dia, "..blackWeekly.."/semana, "..blackMonthly.."/mes\n"
	if whiteSkullWait > 0 then
		message = message.."White PK restante: "..math.floor(whiteSkullWait / 60).." minuto(s) e "..(whiteSkullWait % 60).." segundo(s)\n"
	end
	message = message.."Tempo para poder recolher/trocar o Pokemon: "..returnWait.." segundo(s)."
	doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, message)
	return true
end
-- END Pokemon PvP Frag System
