
local OpcodeDialog = 80
local Actions = {
  open = 1,
  closed = 2
}

function doSendDialogNpc(cid, npc, msg, opc)
  if ( not opc ) then
    opc = ''
  end
  doSendPlayerExtendedOpcode(cid, OpcodeDialog, table.serialize({ action = Actions.open, data = { npcId = npc, message = msg, options = opc } })) 
end

function doSendDialogNpcClose(cid)
  doSendPlayerExtendedOpcode(cid, OpcodeDialog, table.serialize({ action = Actions.closed }))
end


table.serialize = function(x, recur)
  local t = type(x)
  recur = recur or {}

  if t == nil then
    return "nil"
  elseif t == "string" then
  return string.format("%q", x)
  elseif t == "number" then
  return tostring(x)
  elseif t == "boolean" then
  return t and "true" or "false"
  elseif getmetatable(x) then
  error("Can not serialize a table that has a metatable associated with it.")
  elseif t == "table" then
    if(table.find(recur, x)) then
    error("Can not serialize recursive tables.")
  end
  table.insert(recur, x)

  local s = "{"
  for k, v in pairs(x) do
    s = s .. "[" .. table.serialize(k, recur) .. "]"
    s = s .. " = " .. table.serialize(v, recur) .. ","
  end
  s = s .. "}"
  return s
  else
  error("Can not serialize value of type '" .. t .. "'.")
  end
end