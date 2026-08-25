local tpId = 1387
local tps = {

	["Boss Exemplo"] = {pos = {x = 1674, y = 1340, z = 12}, toPos = {x = 1674, y = 1336, z = 12}, time = 20}, ---- Nome do monstro, pos = aonde abrir o portal topos= aonde esse portl leva. Registrar a tag portais no xml do boss. Veja o Boss Exemplo na pasta monster

	

}

function removeTp(tp)
	local t = getTileItemById(tp.pos, tpId)
	if t then
		doRemoveItem(t.uid, 1)
		doSendMagicEffect(tp.pos, CONST_ME_POFF)
	end
end

function onDeath(cid)
	local tp = tps[getCreatureName(cid)]
	
	if not tp then 
		return true
	end
	
	local tp = tps[getCreatureName(cid)]
	local DEATH = tp.DEATH
	
	if not tp then return true end
	
	if tp then 
	local check = tp.pos
	local check2 = tp.toPos
	
	local CheckPosx = check.x
	local CheckPosy = check.y
	local CheckPosz = check.z
	
	
	local CheckPosx2 = check2.x
	local CheckPosy2 = check2.y
	local CheckPosz2 = check2.z
	
	if CheckPosx == CheckPosx2 and CheckPosy == CheckPosy2 and CheckPosz == CheckPosz2 then
		doCreatureSay(cid, "QUEST BUGADA!!!, avise o adm!!!", TALKTYPE_ORANGE_1)
		return true
	end 	
			doCreateTeleport(tpId, tp.toPos, tp.pos)
			doCreatureSay(cid, "O teleport irá sumir em "..tp.time.." segundos.", TALKTYPE_ORANGE_1)
			addEvent(removeTp, tp.time*1000, tp)
	return true end
end
