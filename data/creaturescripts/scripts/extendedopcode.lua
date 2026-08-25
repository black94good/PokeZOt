OPCODE_LANGUAGE = 1

function onExtendedOpcode(cid, opcode, buffer)
  if opcode == OPCODE_LANGUAGE then
    if buffer == 'en' or buffer == 'pt' then end
  elseif opcode == 244 then
  return true
  elseif opcode == 28 then
    if string.find(buffer, '###SEARCH###') then
      searchFigures(cid, string.explode(buffer, '###SEARCH###')[2])
    elseif string.find(buffer, '###PAGE###') then
      sendFigures(cid, tonumber(string.explode(buffer, '###PAGE###')[2]))
    end
  elseif opcode == 12 then
    if string.find(buffer, "###ALLTASKS###") then
      sendTasks(cid)
    elseif string.find(buffer, "###ADDTASK###") then
      tryAddRandomTask(cid, tonumber(string.explode(buffer, "###ADDTASK###")[1]))
    elseif string.find(buffer, "###BUYITEM###") then
      buyTaskShopItem(cid, tonumber(string.explode(buffer, "###BUYITEM###")[1]))
    elseif string.find(buffer, "###SHOP###") then
      sendTaskShop(cid)
    end
  elseif opcode == 11 then
    if string.find(buffer, 'REQUEST') then
      local explode = string.explode(buffer, 'REQUEST')
      getDailyRewards(cid, explode[1], explode[2])
    elseif string.find(buffer, 'COLLECT') then
      collectDailyReward(cid)
    elseif string.find(buffer, "###BUYITEM###") then
      buyDRShopItem(cid, tonumber(string.explode(buffer, "###BUYITEM###")[1]))
    end
  elseif opcode == TeleportQuest.Opcode then   
      TeleportQuest.onExtendedOpcode(cid, buffer)
  elseif opcode == TeleportQuest2.Opcode then   
      TeleportQuest2.onExtendedOpcode(cid, buffer)
  end
  return true
end