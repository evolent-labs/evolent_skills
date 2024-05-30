local conf = require 'config'

local framework = conf.Framework
local coreObject
if framework == 'qb' then
    coreObject = exports['qb-core']:GetCoreObject()
elseif framework == 'esx' then
    coreObject = exports['esx_core']:getSharedObject()
end

local fwFunctions = {}

---@param source number
---@return string charId
function fwFunctions.getCharacterIdentifier(source)
    local charId
    if framework == 'qb' then
        local player = coreObject.Functions.GetPlayer(source)
        charId = player.PlayerData.citizenid
    elseif framework == 'esx' then
        local player = coreObject.GetPlayerFromIdentifier(source)
        charId = player.getIdentifier()
    end
    return charId
end

return fwFunctions
