function onSay(cid, words, param)
if(doPlayerRemoveItem(cid, 2145, 18) == true) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns!! Agora você é um Jogador VIP.")
doPlayerAddPremiumDays(cid, 60)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Vocé Precisa De 18 Diamond para Adquirir VIP.")
end
return TRUE
end

