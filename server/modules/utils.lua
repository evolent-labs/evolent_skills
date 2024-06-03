local conf = require 'config'

local utils = {}

---@param skillName string
local function precomputeXpRequirements(skillName)
    local skillConfig = conf.Skills[skillName]
    if not skillConfig then
        error(('Skill \'%s\' is not configured!'):format(skillName), 1)
    end

    local xpTable = {}
    local currentMaxXp = skillConfig.baseXp
    xpTable[1] = currentMaxXp

    for level = 2, skillConfig.maxLevel do
        currentMaxXp = math.ceil(currentMaxXp * skillConfig.nextLevelMultiplier)
        xpTable[level] = currentMaxXp
    end

    return xpTable
end

utils.xpTables = {}
for skillName in pairs(conf.Skills) do
    utils.xpTables[skillName] = precomputeXpRequirements(skillName)
end

---@param xpAmount number
---@param skillName string
function utils.calculateLevel(xpAmount, skillName)
    local xpTable = utils.xpTables[skillName]
    local level = 1
    while level < #xpTable and xpAmount >= xpTable[level] do
        level = level + 1
    end
    return level
end

function utils.getXpRangeForLevel(level, skillName)
    local xpTable = utils.xpTables[skillName]
    if not xpTable then
        error(('Skill \'%s\' is not configured!'):format(skillName), 1)
    end

    local minXp = (level > 1) and xpTable[level - 1] or 0
    local maxXp
    if level < #xpTable then
        maxXp = xpTable[level]
    else
        maxXp = math.ceil(xpTable[level] * conf.Skills[skillName].nextLevelMultiplier)
    end

    return minXp, maxXp
end

---@param source number
---@param skill string
---@param target number
---@param value number
---@param isLevel boolean
function utils.validateSkillCommand(source, skill, target, value, isLevel)
    if not conf.Skills[skill] then
        lib.notify(source, {
            title = 'Skills',
            description = ('Skill %s does not exist'):format(skill),
            type = 'error'
        })
        return false
    end

    if not DoesPlayerExist(target) then
        lib.notify(source, {
            title = 'Skills',
            description = ('Player with the ID of %d does not exist'):format(target),
            type = 'error'
        })
        return false
    end

    if isLevel then
        if type(value) ~= 'number' or value <= 0 or value > conf.Skills[skill].maxLevel then
            lib.notify(source, {
                title = 'Skills',
                description = ('Level must be a number between 1 and %d'):format(conf.Skills[skill].maxLevel),
                type = 'error'
            })
            return false
        end
    else
        if type(value) ~= 'number' or value <= 0 then
            lib.notify(source, {
                title = 'Skills',
                description = 'Amount of XP must be a positive number',
                type = 'error'
            })
            return false
        end
    end

    return true
end

return utils
