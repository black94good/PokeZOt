local config = {
	loginMessage = getConfigValue('loginMessage'),
	useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
}

function onLogin(cid)
	iniciais(cid)
	
	local accountManager = getPlayerAccountManager(cid)
 if getPlayerLevel(cid) >= 1 and getPlayerLevel(cid) <= 80 then
	doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, 90)
	doCreatureSetDropLoot(cid, false)
end
   if getPlayerLevel(cid) >= 81 and getPlayerLevel(cid) <= 149 then
	doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, 80)
	doCreatureSetDropLoot(cid, false)
end
   if getPlayerLevel(cid) >= 150 then
	doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, 75)
	doCreatureSetDropLoot(cid, false)
end

	if(accountManager == MANAGER_NONE) then
		local lastLogin, str = getPlayerLastLoginSaved(cid), config.loginMessage
		if(lastLogin > 0) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
			str = "Your last visit was on " .. os.date("%a %b %d %X %Y", lastLogin) .. "."
		else
			str = str
		end

		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)

	elseif(accountManager == MANAGER_NAMELOCK) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, it appears that your character has been namelocked, what would you like as your new name?")
	elseif(accountManager == MANAGER_ACCOUNT) then
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, type 'account' to manage your account and if you want to start over then type 'cancel'.")
	else
		doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Hello, type 'account' to create an account or type 'recover' to recover an account.")
	end



	if(not isPlayerGhost(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end



	registerCreatureEvent(cid, "dropStone")
    registerCreatureEvent(cid, "ShowPokedex") --alterado v1.6
    registerCreatureEvent(cid, "ClosePokedex") --alterado v1.6 
	registerCreatureEvent(cid, "WatchTv")
	registerCreatureEvent(cid, "StopWatchingTv")
	registerCreatureEvent(cid, "WalkTv")
	registerCreatureEvent(cid, "RecordTv")
	registerCreatureEvent(cid, "PlayerLogout")
	registerCreatureEvent(cid, "WildAttack")
	registerCreatureEvent(cid, "Idle")
	registerCreatureEvent(cid, "PokemonIdle")
	registerCreatureEvent(cid, "EffectOnAdvance")
	registerCreatureEvent(cid, "GeneralConfiguration")
	registerCreatureEvent(cid, "ReportBug")
	registerCreatureEvent(cid, "LookSystem")
	registerCreatureEvent(cid, "T1")
	registerCreatureEvent(cid, "T2")
	registerCreatureEvent(cid, "task_count")
	registerCreatureEvent(cid, "pokemons")

	local lootEvents = {
      "AutoLootReceive", "AutoLootChangeCategory", "AutoLootAdd",
     "AutoLootRemove", "AutoLootStatus"
   }
   
   for _, evt in ipairs(lootEvents) do 
   	registerCreatureEvent(cid, evt) 
   end
   
	

	addEvent(doSendAnimatedText, 500, getThingPosWithDebug(cid), "Bem Vindo!!", COLOR_BURN)

	if getPlayerStorageValue(cid, 99284) == 1 then
		setPlayerStorageValue(cid, 99284, -1)
	end

    if getPlayerStorageValue(cid, 6598754) >= 1 or getPlayerStorageValue(cid, 6598755) >= 1 then
       setPlayerStorageValue(cid, 6598754, -1)
       setPlayerStorageValue(cid, 6598755, -1)
       doRemoveCondition(cid, CONDITION_OUTFIT)             --alterado v1.9 \/
       doTeleportThing(cid, posBackPVP, false)
       doCreatureAddHealth(cid, getCreatureMaxHealth(cid))
    end
    
	doChangeSpeed(cid, -(getCreatureSpeed(cid)))
	
	--///////////////////////////////////////////////////////////////////////////--
    local storages = {17000, 63215, 17001, 13008, 5700}
    for s = 1, #storages do
        if not tonumber(getPlayerStorageValue(cid, storages[s])) then
           if s == 3 then
              setPlayerStorageValue(cid, storages[s], 1)
           elseif s == 4 then
              setPlayerStorageValue(cid, storages[s], -1)
           else   
              if isBeingUsed(getPlayerSlotItem(cid, 8).itemid) then
                 setPlayerStorageValue(cid, storages[s], 1)                 
              else
                 setPlayerStorageValue(cid, storages[s], -1) 
              end
           end
           doPlayerSendTextMessage(cid, 27, "Sorry, but a problem occurred on the server, but now it's alright")
        end
    end
    --/////////////////////////////////////////////////////////////////////////--
	-- START Pokemon Transportation System
	-- A source salva a outfit padrao (lookType e cores) no logout e na morte.
	-- Aqui apenas restauramos a forma temporaria do transporte sobre essas cores.
	local transportActive = getPlayerStorageValue(cid, 17000) >= 1
		or getPlayerStorageValue(cid, 63215) >= 1
		or getPlayerStorageValue(cid, 17001) >= 1
	-- START Pokemon Transportation Outfit Colors
	local outfitTransportActive = transportActive
		or getPlayerStorageValue(cid, 5700) >= 1
		or getPlayerStorageValue(cid, 13008) >= 1
	local hasSavedTransportOutfit = getPlayerStorageValue(cid, TRANSPORT_OUTFIT_STORAGES.saved) == 1

	if outfitTransportActive then
		if not hasSavedTransportOutfit then
			-- Compatibilidade com personagens que deslogaram montados antes desta correcao.
			doRemoveCondition(cid, CONDITION_OUTFIT)
			savePokemonTransportBaseOutfit(cid)
		end
		-- Regrava a defaultOutfit correta antes de aplicar novamente a forma montada.
		restorePokemonTransportBaseOutfit(cid, false)
	elseif hasSavedTransportOutfit then
		-- Recupera e limpa uma outfit pendente quando morte/logout encerrou o transporte.
		restorePokemonTransportBaseOutfit(cid, true)
	end
	-- END Pokemon Transportation Outfit Colors
	local transportBall = false
	local transportPoke = nil
	if transportActive then
		transportBall = getMountedPokemonBall(cid)
		transportPoke = transportBall and getItemAttribute(transportBall.uid, "poke") or nil
		local transportConfigured = transportBall and (
			(getPlayerStorageValue(cid, 17000) >= 1 and flys[transportPoke])
			or (getPlayerStorageValue(cid, 63215) >= 1 and surfs[transportPoke])
			or (getPlayerStorageValue(cid, 17001) >= 1 and rides[transportPoke])
		)
		if not transportBall or not transportConfigured then
			setPlayerStorageValue(cid, 17000, -1)
			setPlayerStorageValue(cid, 63215, -1)
			setPlayerStorageValue(cid, 17001, -1)
			clearMountedPokemonBall(cid)
			-- START Pokemon Transportation Outfit Colors
			restorePokemonTransportBaseOutfit(cid, true)
			-- END Pokemon Transportation Outfit Colors
		end
	end
	-- END Pokemon Transportation System
	if getPlayerStorageValue(cid, 17000) >= 1 and transportBall and flys[transportPoke] then -- fly
        
		-- START Pokemon Transportation System
		local item = transportBall
		local poke = transportPoke
		doChangeSpeed(cid, getPlayerStorageValue(cid, 54844))
		doRemoveCondition(cid, CONDITION_OUTFIT)
		local addon = tonumber(getItemAttribute(item.uid, "addon") or 0)
		if addon > 0 and flysAddon[addon] then
			applyPokemonTransportOutfit(cid, flysAddon[addon][1])
		else
			applyPokemonTransportOutfit(cid, flys[poke][1] + 351)
		end
		-- END Pokemon Transportation System

	local apos = getFlyingMarkedPos(cid)
    apos.stackpos = 0
		
			if getTileThingByPos(apos).itemid <= 2 then
				doCombatAreaHealth(cid, FIREDAMAGE, getFlyingMarkedPos(cid), 0, 0, 0, CONST_ME_NONE)
				doCreateItem(460, 1, getFlyingMarkedPos(cid))
			end 

	doTeleportThing(cid, apos, false)
	if getItemAttribute(item.uid, "boost") and getItemAttribute(item.uid, "boost") >= 50 and getPlayerStorageValue(cid, 42368) >= 1 then
	   local aura = tonumber(getItemAttribute(item.uid, "aura"))
	   if aura and auraSyst[aura] then sendAuraEffect(cid, auraSyst[aura]) end
    end  
 
    local posicao = getTownTemplePosition(getPlayerTown(cid))
    markFlyingPos(cid, posicao)
    
	elseif getPlayerStorageValue(cid, 63215) >= 1 and transportBall and surfs[transportPoke] then -- surf

		-- START Pokemon Transportation System
		local item = transportBall
		local poke = transportPoke
		local addon = tonumber(getItemAttribute(item.uid, "addon") or 0)
		if addon > 0 and surfsAddon[addon] then
			applyPokemonTransportOutfit(cid, surfsAddon[addon][1])
		else
			applyPokemonTransportOutfit(cid, surfs[poke].lookType + 351)
		end
		-- END Pokemon Transportation System
		doChangeSpeed(cid, getPlayerStorageValue(cid, 54844))
		if getItemAttribute(item.uid, "boost") and getItemAttribute(item.uid, "boost") >= 50 and getPlayerStorageValue(cid, 42368) >= 1 then
		   local aura = tonumber(getItemAttribute(item.uid, "aura"))
		   if aura and auraSyst[aura] then sendAuraEffect(cid, auraSyst[aura]) end
        end 

	elseif getPlayerStorageValue(cid, 17001) >= 1 and transportBall and rides[transportPoke] then -- ride
        
		-- START Pokemon Transportation System
		local item = transportBall
		local poke = transportPoke
		
		
		if rides[poke] then
		   doChangeSpeed(cid, getPlayerStorageValue(cid, 54844))
		   doRemoveCondition(cid, CONDITION_OUTFIT)
		   local addon = tonumber(getItemAttribute(item.uid, "addon") or 0)
		   if addon > 0 and ridesAddon[addon] then
		      applyPokemonTransportOutfit(cid, ridesAddon[addon][1])
		   else
		      applyPokemonTransportOutfit(cid, rides[poke][1] + 351)
		   end
		   if getItemAttribute(item.uid, "boost") and getItemAttribute(item.uid, "boost") >= 50 and getPlayerStorageValue(cid, 42368) >= 1 then
		      local aura = tonumber(getItemAttribute(item.uid, "aura"))
		      if aura and auraSyst[aura] then sendAuraEffect(cid, auraSyst[aura]) end
           end 
		else
		   setPlayerStorageValue(cid, 17001, -1)
		   doRegainSpeed(cid)   
		end
		-- END Pokemon Transportation System
	
	    local posicao2 = getTownTemplePosition(getPlayerTown(cid))
        markFlyingPos(cid, posicao2)
        
	elseif getPlayerStorageValue(cid, 13008) >= 1 then -- dive
       if not isInArray({5405, 5406, 5407, 5408, 5409, 5410}, getTileInfo(getThingPos(cid)).itemid) then
			setPlayerStorageValue(cid, 13008, 0)
			doRegainSpeed(cid)              
			doRemoveCondition(cid, CONDITION_OUTFIT)
		return true
		end   
          
	   -- START Pokemon Transportation System
	   applyPokemonTransportOutfit(cid, getPlayerSex(cid) == 1 and 1034 or 1035)
	   -- END Pokemon Transportation System
       doChangeSpeed(cid, 800)

     elseif getPlayerStorageValue(cid, 5700) > 0 then   --bike
		-- START Pokemon Transportation System
        doChangeSpeed(cid, -getCreatureSpeed(cid))
		doChangeSpeed(cid, 2000)
		applyPokemonTransportOutfit(cid, getPlayerSex(cid) == 1 and 162 or 161)
		-- END Pokemon Transportation System
     
     elseif getPlayerStorageValue(cid, 75846) >= 1 then     --alterado v1.9 \/
        doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false)  
        setPlayerStorageValue(cid, 75846, -1)
        sendMsgToPlayer(cid, 20, "You have been moved to your town!")
	 else
		doRegainSpeed(cid)  
	 end
	
	if getPlayerStorageValue(cid, 22545) >= 1 then
	   setPlayerStorageValue(cid, 22545, -1)              
	   doTeleportThing(cid, getClosestFreeTile(cid, posBackGolden), false)
       setPlayerRecordWaves(cid)     
    end
    
if useKpdoDlls then
  doUpdateMoves(cid)
  onPokeHealthChange(cid)
  -- START Pokebar System
  addEvent(doUpdatePokemonsBar, 750, cid)
  -- END Pokebar System
end


	
	
	return true
end
