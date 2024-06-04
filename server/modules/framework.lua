local conf = require 'config'

local function createFrameworkAdapter(framework)
    local adapter = {}

    if framework == 'qb' then
        local coreObject = exports['qb-core']:GetCoreObject()
        function adapter.getCharacterIdentifier(source)
            local player = coreObject.Functions.GetPlayer(source)
            return player and player.PlayerData.citizenid or nil
        end
    elseif framework == 'esx' then
        local coreObject = exports['es_extended']:getSharedObject()
        function adapter.getCharacterIdentifier(source)
            local player = coreObject.GetPlayerFromId(source)
            return player and player.getIdentifier() or nil
        end
    end

    return adapter
end

local fwFunctions = createFrameworkAdapter(conf.Framework)

return fwFunctions
