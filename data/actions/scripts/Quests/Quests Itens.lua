local Quests = {

	[40000] = {questName = "Quest Exemplo", storageId = 54334, premium = false, teleportHome = true, reward = {{2145, 4}, {2145, 4}, {2145, 4}}},
	[40001] = {questName = "Fire Stone", storageId = 54334, premium = false, teleportHome = true, reward = {{11447, 10}}},




}

function onUse(cid, item, fromPosition, itemEx, toPosition)
	if not Quests[item.actionid] then
		return true
	end
	
	local quest = Quests[item.actionid]
	local storage = quest.storageId
	local premio = quest.questName

	if getPlayerStorageValue(cid, storage) >= 1 then
		Escrever(cid, "Você ja fez essa quest!!")
		return true
	end
	
	if quest.premium and not isPremium(cid) then
		doPlayerSendCancel(cid, "You need be premium to do this quest!")
		return true
	end
	
	local itemsName = {}
	local rewardItemid, count = 0, 0
	
	if getPlayerStorageValue(cid, storage) < 1 then
		for _, items in pairs(quest.reward) do
			count = items[2]
			rewardItemid = items[1]
			table.insert(itemsName, count.."x "..getItemNameById(rewardItemid))
			doPlayerAddItem(cid, rewardItemid, count)
		end	
	end

	if quest.teleportHome == true then 
		MandarCp(cid)
	end

	
	local text = "Você terminou a ".. quest.questName
	
	if not quest.customMessage == "" then
		text = quest.customMessage
	end
		doPlayerSendTextMessage(cid, 20, text)
		setPlayerStorageValue(cid, quest.storageId, 1)
	 
return true 
end
