local conf = require 'config'

local utils = {}

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

return utils
