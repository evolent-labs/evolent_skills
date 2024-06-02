local db = require 'server.modules.db'
local utils = require 'server.modules.utils'
local framework = require 'server.modules.framework'
local conf = require 'config'

local skills = {}
local skillsCache = {}

local function _warn(functionName, message)
    local resource = GetInvokingResource()
    warn(string.format("[%s] %s: %s", resource, functionName, message))
end

local function isValidSource(source)
    if not DoesPlayerExist(source) then
        _warn("isValidSource", "Invalid source: " .. tostring(source))
        return false
    end
    return true
end

local function isValidSkillName(skillName)
    if type(skillName) ~= "string" or conf.Skills[skillName] == nil then
        _warn("isValidSkillName", "Invalid skill name: " .. tostring(skillName))
        return false
    end
    return true
end

local function isValidXpAmount(xpAmount)
    if type(xpAmount) ~= "number" or xpAmount < 0 then
        _warn("isValidXpAmount", "Invalid XP amount: " .. tostring(xpAmount))
        return false
    end
    return true
end

local function isValidLevel(level)
    if type(level) ~= "number" or level <= 0 then
        _warn("isValidLevel", "Invalid level: " .. tostring(level))
        return false
    end
    return true
end

local function updateSkillCache(source, skillName, xpAmount)
    skillsCache[source][skillName].xp = skillsCache[source][skillName].xp + xpAmount
    skillsCache[source][skillName].level = utils.calculateLevel(skillsCache[source][skillName].xp, skillName)
end

---@param source number
---@param skillName string
---@param xpAmount number
function skills.addXp(source, skillName, xpAmount)
    if not isValidSource(source) then return end
    if not isValidSkillName(skillName) then return end
    if not isValidXpAmount(xpAmount) then return end

    local charId = framework.getCharacterIdentifier(source)
    db.addXp(charId, skillName, xpAmount)
    updateSkillCache(source, skillName, xpAmount)
end

exports('addXp', skills.addXp)

---@param source number
---@param skillName string
---@param xpAmount number
function skills.removeXp(source, skillName, xpAmount)
    if not isValidSource(source) then return end
    if not isValidSkillName(skillName) then return end
    if not isValidXpAmount(xpAmount) then return end

    local charId = framework.getCharacterIdentifier(source)

    local currentXp = skillsCache[source][skillName].xp
    local newXpAmount = math.max(0, currentXp - xpAmount)
    local xpRemoved = currentXp - newXpAmount

    db.removeXp(charId, skillName, xpRemoved)
    updateSkillCache(source, skillName, -xpRemoved)
end

exports('removeXp', skills.removeXp)

---@param source number
---@param skillName string
function skills.getSkillLevel(source, skillName)
    if not isValidSource(source) then return end
    if not isValidSkillName(skillName) then return end

    return skillsCache[source] and skillsCache[source][skillName] and skillsCache[source][skillName].level or 0
end

exports('getSkillLevel', skills.getSkillLevel)

---@param source number
---@param skillName string
function skills.getSkillXp(source, skillName)
    if not isValidSource(source) then return end
    if not isValidSkillName(skillName) then return end

    return skillsCache[source] and skillsCache[source][skillName] and skillsCache[source][skillName].xp or 0
end

exports('getSkillXp', skills.getSkillXp)

---@param source number
---@param skillName string
---@param level number
function skills.setSkillLevel(source, skillName, level)
    if not isValidSource(source) then return end
    if not isValidSkillName(skillName) then return end
    if not isValidLevel(level) then return end

    local charId = framework.getCharacterIdentifier(source)
    local xpTable = utils.xpTables[skillName]

    if level > #xpTable then
        return lib.notify(source, {
            title = 'Error',
            description = 'Level is out of range for this skill.',
            type = 'error'
        })
    end

    local xpAmount = (level > 1) and (xpTable[level - 1]) or 0
    db.setXp(charId, skillName, xpAmount)
    skillsCache[source][skillName] = { xp = xpAmount, level = level }
end

exports('setSkillLevel', skills.setSkillLevel)

---@param source number
---@param skillName string
function skills.resetSkill(source, skillName)
    if not isValidSource(source) then return end
    if not isValidSkillName(skillName) then return end

    local charId = framework.getCharacterIdentifier(source)
    db.resetSkill(charId, skillName)
    skillsCache[source][skillName] = { xp = 0, level = 1 }
end

exports('resetSkill', skills.resetSkill)

---@param source number
function skills.getAllSkills(source)
    if not isValidSource(source) then return end

    return skillsCache[source] or {}
end

exports('getAllSkills', skills.getAllSkills)

---@param source number
---@param skillName string
function skills.hasSkill(source, skillName)
    if not isValidSource(source) then return end
    if not isValidSkillName(skillName) then return end

    return skillsCache[source] and skillsCache[source][skillName] ~= nil
end

exports('hasSkill', skills.hasSkill)

---@param source number
function skills.playerLoaded(source)
    local charId = framework.getCharacterIdentifier(source)
    if not charId then return end

    if not skillsCache[source] then
        local playerSkills = db.getPlayerSkills(charId)
        local playerSkillSet = {}
        for _, pSkillData in ipairs(playerSkills) do
            playerSkillSet[pSkillData.skill_name] = {
                xp = pSkillData.xp,
                level = utils.calculateLevel(pSkillData.xp, pSkillData.skill_name)
            }
        end
        skillsCache[source] = playerSkillSet
    end

    for skillName, _ in pairs(conf.Skills) do
        if not skillsCache[source][skillName] then
            db.insertNewPlayerSkill(charId, skillName)
            skillsCache[source][skillName] = { xp = 0, level = 1 }
        end
    end
end

return skills
