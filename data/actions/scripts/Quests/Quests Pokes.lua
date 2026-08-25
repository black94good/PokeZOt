local Quests = {

	---- Iniciante
	[7500] = {questName = "Abra", boost = 25,  storageId = 918204, premium = false, level = 1, teleportHome = true},

	[7501] = {questName = "Dragonite", boost = 100,  storageId = 918205, premium = false, level = 1, teleportHome = true},



}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not Quests[item.actionid] then
		return true
	end
	
	local quest = Quests[item.actionid]
	

	if getPlayerStorageValue(cid, quest.storageId) >= 1 then
		doPlayerSendCancel(cid, "You've finished this quest!")
		return true
	end
	
	if getPlayerStorageValue(cid, 8955) ~= 1 then
		setPlayerStorageValue(cid, 8955, 1)
	end

	if getPlayerLevel(cid) < quest.level then
		doPlayerSendCancel(cid, "You need be level ".. quest.level .." to do this quest!")
		return true
	end
	
	if quest.premium and not isPremium(cid) then
		doPlayerSendCancel(cid, "You need be premium to do this quest!")
		return true
	end
	
	local quest = Quests[item.actionid]
	local boost = quest.boost	
	local teleportHome = quest.teleportHome

	setPlayerStorageValue(cid, quest.storageId, 1)
	Escrever(cid, "Pokemon adquirido: "..quest.questName)
	addPokeToPlayer(cid, quest.questName, boost, nil, btype)



	if teleportHome == true then 
		MandarCp(cid)
		return true
	end
	
	return true  
end
