local conf = require 'config'

local function createFrameworkAdapter(framework)
    local adapter = {}

    if framework == 'qb' then
        local coreObject = exports['qb-core']:GetCoreObject()
        function adapter.getCharacterIdentifier(source)
            return coreObject.Functions.GetPlayer(source)?.PlayerData?.citizenid
        end
    elseif framework == 'qbx' then
        function adapter.getCharacterIdentifier(source)
            return exports.qbx_core:GetPlayer(source)?.PlayerData?.citizenid
        end
    elseif framework == 'esx' then
        local coreObject = exports['es_extended']:getSharedObject()
        function adapter.getCharacterIdentifier(source)
            local player = coreObject.GetPlayerFromId(source)
            return player and player.getIdentifier() or nil
        end
    elseif framework == 'ox' then
        local coreObject = require "@ox_core.lib.init"

        function adapter.getCharacterIdentifier(source)
            local player = coreObject.GetPlayer(source)
            return player and player.stateId or nil
        end
    end

    return adapter
end

local fwFunctions = createFrameworkAdapter(conf.Framework)

return fwFunctions
