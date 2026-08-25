function onSay(cid, words, param)
local pos = {x = 1048, y = 1044, z = 7}
	doPlayerSendCancel(cid,"Teleportado!")
	doTeleportThing(cid,pos)
	if getPlayerStorageValue(cid, 80000) ~= 2 then 
		outfitBase(cid)
		local soma = getPlayerStorageValue(cid, 80000) + 1
		setPlayerStorageValue(cid, 80000, soma) 
		addEvent(function()
	    doCreatureExecuteTalkAction(cid, "!bug")
	end, 1000)
		return true
	end
	return true
end