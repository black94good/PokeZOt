local fishing = {
	["Magikarp"] = {skill = 0, level = -2},
	["Qwilfish"] = {skill = 18, level = 3},
	["Remoraid"] = {skill = 16, level = 2},
	["Staryu"] = {skill = 22, level = 6},
	["Tentacool"] = {skill = 20, level = 7},
	["Goldeen"] = {skill = 17, level = 5},
	["Krabby"] = {skill = 14, level = 2},
	["Horsea"] = {skill = 16, level = 3},
	["Poliwag"] = {skill = 15, level = 2},
	["Marill"] = {skill = 21, level = 3},
	["Azumarill"] = {skill = 37, level = 16},
	["Kingler"] = {skill = 35, level = 14},
	["Seaking"] = {skill = 28, level = 11},
	["Starmie"] = {skill = 49, level = 20},
	["Chinchou"] = {skill = 23, level = 6},
	["Poliwhirl"] = {skill = 27, level = 9},
	["Seadra"] = {skill = 41, level = 15},
	["Lanturn"] = {skill = 38, level = 14},
	["Octillery"] = {skill = 30, level = 9},
	["Corsola"] = {skill = 46, level = 16},
	["Blastoise"] = {skill = 50, level = 30},
	["Omastar"] = {skill = 60, level = 100},
	["Marill"] = {skill = 60, level = 100},
	["Kabuto"] = {skill = 70, level = 100},
	["Kabutops"] = {skill = 80, level = 100},
	["Gyarados"] = {skill = 80, level = 100},
	["Tentacruel"] = {skill = 80, level = 100},
	["Vaporeon"] = {skill = 90, level = 100},
	["Kingdra"] = {skill = 100, level = 100},
	["Shiny Blastoise"] = {skill = 100, level = 100},
	["Shiny Tentacruel"] = {skill = 100, level = 100},
	["Shiny Gyarados"] = {skill = 100, level = 100},
	["Shellder"] = {skill = 1, level = 100},
	["Seel"] = {skill = 20, level = 100},
	["Dewgong"] = {skill = 80, level = 100},
	["Cloyster"] = {skill = 80, level = 100},
}

local storage = 15458
local bonus = 1
local limite = 120


local function doFish(cid, pos, ppos, chance, interval, number)
	if not isCreature(cid) then return false end
	
	if getThingPos(cid).x ~= ppos.x or getThingPos(cid).y ~= ppos.y then
	return false end
	
	if getPlayerStorageValue(cid, storage) ~= number then return false end
	
	doSendMagicEffect(pos, CONST_ME_LOSEENERGY)
	
	local peixe = 0
	local playerpos = getClosestFreeTile(cid, getThingPos(cid))
	local fishes = {}
	local randomfish = ""
	
	--alterado!!
	if getPlayerSkillLevel(cid, 6) < limite then
		doPlayerAddSkillTry(cid, 6, bonus)
	end
	
	for a, b in pairs (fishing) do
		if getPlayerSkillLevel(cid, 6) >= b.skill then
			table.insert(fishes, a)
		end
	end
	
	if math.random(1, 10) <= chance then
		if getPlayerSkillLevel(cid, 6) < limite then
			doPlayerAddSkillTry(cid, 6, bonus)
		end
		randomfish = fishes[math.random(#fishes)]
		peixe = doSummonCreature(randomfish, playerpos)
		if not isCreature(peixe) then
			addEvent(doFish, interval, cid, pos, ppos, chance, interval, number)
			return true
		end
		doSetMonsterPassive(peixe)
		doWildAttackPlayer(peixe, cid)
		if #getCreatureSummons(cid) >= 1 then
			doSendMagicEffect(getThingPos(getCreatureSummons(cid)[1]), 173)
			doChallengeCreature(getCreatureSummons(cid)[1], peixe)
			else
			doSendMagicEffect(getThingPos(cid), 173)
			doChallengeCreature(cid, peixe)
		end
		return true
	end
	addEvent(doFish, interval, cid, pos, ppos, chance, interval, number)
	return true
end

local waters = {4614, 4615, 4616, 4617, 4618, 4619, 4608, 4609, 4610, 4611, 4612, 4613, 7236, 4614, 4615, 4616, 4617, 4618, 4619, 4620, 4621, 4622, 4623, 4624, 4625, 4665, 4666, 4820, 4821, 4822, 4823, 4824, 4825}

function onUse(cid, item, fromPos, itemEx, toPos)
	
	if getPlayerGroupId(cid) == 11 then
		return true
	end
	
	local checkPos = toPos
	checkPos.stackpos = 0
	
	if getTileThingByPos(checkPos).itemid <= 0 then
		doPlayerSendCancel(cid, '!')
		return true
	end
	
	if not isInArray(waters, getTileInfo(toPos).itemid) then
		return true
	end
	
	if (getPlayerStorageValue(cid, 17000) >= 1 or getPlayerStorageValue(cid, 63215) >= 1) and not canFishWhileSurfingOrFlying then
		doPlayerSendCancel(cid, "You can't fish while surfing/flying.")
		return true
	end
	
	if isInArray(waters, getTileInfo(getThingPos(cid)).itemid) then
		doPlayerSendCancel(cid, "You can\'t fish while surfing neither flying above water.")
		return true
	end
	
	if getTileInfo(getThingPos(getCreatureSummons(cid)[1] or cid)).protection then
		doPlayerSendCancel(cid, "You can't fish pokémons if you or your pokémon is in protection zone.")
		return true
	end
	
	if not tonumber(getPlayerStorageValue(cid, storage)) then
		local test = io.open("data/sendtobrun123.txt", "a+")
		local read = ""
		if test then
			read = test:read("*all")
			test:close()
		end
		read = read.."\n[fishing.lua] "..getCreatureName(cid).." - "..getPlayerStorageValue(cid, storage)..""
		local reopen = io.open("data/sendtobrun123.txt", "w")
		reopen:write(read)
		reopen:close()
		setPlayerStorageValue(cid, storage, 1)
	end
	
	setPlayerStorageValue(cid, storage, getPlayerStorageValue(cid, storage) + 1)
	if getPlayerStorageValue(cid, storage) >= 800 then
		setPlayerStorageValue(cid, storage, 1)
	end
	
	local delay = 3500 - getPlayerSkillLevel(cid, 6) * 25
	local chance = 5.2 + getPlayerSkillLevel(cid, 6) / 9.5
	
	doFish(cid, toPos, getThingPos(cid), chance, delay, getPlayerStorageValue(cid, storage))
	
	return true
end