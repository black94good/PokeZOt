function onSay(cid, words, param, channel)
local thisball = getPlayerSlotItem(cid, 8)
if getItemAttribute(thisball.uid, "ehditto") then
doItemSetAttribute(thisball.uid, "poke",  "Ditto")
doItemSetAttribute(thisball.uid, "ehditto",  1)
end
end