local skills = require 'server.modules.skills'
local utils = require 'server.modules.utils'
local conf = require 'config'
local db = require 'server.modules.db'

local framework = conf.Framework

local validFrameworks = { qb = true, esx = true }
if not validFrameworks[framework] then
    error(('Framework \'%s\' is not supported.'):format(framework))
end

local onLoadedEvent = framework == 'qb' and 'QBCore:Server:OnPlayerLoaded' or 'esx:playerLoaded'

AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    db.ensurePlayerSkillsTable()

    local activePlayers = GetPlayers()
    for i = 1, #activePlayers do
        ---@diagnostic disable-next-line
        skills.playerLoaded(tonumber(activePlayers[i]))
    end
end)

RegisterNetEvent(onLoadedEvent, function()
    ---@diagnostic disable-next-line
    skills.playerLoaded(source)
end)

lib.callback.register('evolent_skills:server:getSkills', function(source)
    local skillsData = {}
    local skillsCache = skills.getAllSkills(source)
    for skillName, skillInfo in pairs(skillsCache) do
        local skillConfig = conf.Skills[skillName]
        if skillConfig then
            local minXp, maxXp = utils.getXpRangeForLevel(skillInfo.level, skillName)
            local levelData = {
                minXp = minXp,
                maxXp = math.ceil(maxXp)
            }
            table.insert(skillsData, {
                label = skillConfig.label,
                level = skillInfo.level,
                xp = skillInfo.xp,
                levelData = levelData,
                icon = skillConfig.icon,
                color = skillConfig.color
            })
        end
    end
    return skillsData
end)

lib.callback.register('evolent_skills:server:getSkillLevel', function(source, skillName)
    return skills.getSkillLevel(source, skillName)
end)

lib.callback.register('evolent_skills:server:getSkillXp', function(source, skillName)
    return skills.getSkillXp(source, skillName)
end)

lib.callback.register('evolent_skills:server:getAllSkills', function(source)
    return skills.getAllSkills(source)
end)
