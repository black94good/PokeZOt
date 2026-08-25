function onUse(cid, item, frompos, item2, topos)
	
	if item.uid == 7106 then
		queststatus = getPlayerStorageValue(cid,98878)
		if queststatus == -1 then
			doPlayerSendTextMessage(cid,22,"UnUse..")
			doPlayerAddItem(cid,12331,6)
			doPlayerAddItem(cid,2160,500)
			doTeleportThing(cid,{x=512, y=1127, z=7})
			setPlayerStorageValue(cid,98878,1)
			else
			doPlayerSendTextMessage(cid,22,"You Don't Have Permission.")
		end
		else
		return 0
	end
	
	return 1
end 