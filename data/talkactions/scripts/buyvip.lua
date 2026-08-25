function onSay(cid, words, param)
if(doPlayerRemoveItem(cid, 2145, 10) == true) then
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Parabéns!! Agora você é um Jogador VIP.")
doPlayerAddPremiumDays(cid, 30)
else
doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "Vocé Precisa De 10 Diamond para Adquirir VIP.")
end
return TRUE
end

