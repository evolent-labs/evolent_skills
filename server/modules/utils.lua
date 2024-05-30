local conf = require 'config'

local utils = {}

---@param skillName string
---@return table
local function precomputeXpRequirements(skillName)
    local skillConfig = conf.Skills[skillName]
    if not skillConfig then
        error(('Skill \'%s\' is not configured!'):format(skillName), 1)
    end

    local xpTable = {}
    local baseXp = skillConfig.baseXp
    local nextLevelMultiplier = skillConfig.nextLevelMultiplier
    local maxLevel = skillConfig.maxLevel
    local requiredXp = baseXp

    for level = 1, maxLevel do
        xpTable[level] = requiredXp
        requiredXp = requiredXp * nextLevelMultiplier
    end

    return xpTable
end

utils.xpTables = {}
for skillName, _ in pairs(conf.Skills) do
    utils.xpTables[skillName] = precomputeXpRequirements(skillName)
end

---@param xpAmount number
---@param skillName string
function utils.calculateLevel(xpAmount, skillName)
    local skillConfig = conf.Skills[skillName]
    if not skillConfig then
        error(('Skill \'%s\' is not configured!'):format(skillName), 1)
    end

    local level = 1
    local maxLevel = skillConfig.maxLevel
    local xpTable = utils.xpTables[skillName]

    while xpAmount >= xpTable[level] and level < maxLevel do
        xpAmount = xpAmount - xpTable[level]
        level = level + 1
    end

    return level
end

---@param level number
---@param skillName string
---@return number minXp, number maxXp
function utils.getXpRangeForLevel(level, skillName)
    local xpTable = utils.xpTables[skillName]
    if not xpTable then
        error(('Skill \'%s\' is not configured!'):format(skillName), 1)
    end

    local minXp = 0
    for i = 1, level - 1 do
        minXp = minXp + xpTable[i]
    end
    local maxXp = minXp + xpTable[level]
    return minXp, maxXp
end

return utils
