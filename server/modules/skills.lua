local db = require 'server.modules.db'
local utils = require 'server.modules.utils'
local framework = require 'server.modules.framework'
local conf = require 'config'

local skills = {}
local skillsCache = {}

---@param source number
---@param skillName string
---@param xpAmount number
function skills.addXp(source, skillName, xpAmount)
    local charId = framework.getCharacterIdentifier(source)
    db.addXp(charId, skillName, xpAmount)
    skillsCache[source][skillName].xp = skillsCache[source][skillName].xp + xpAmount
    skillsCache[source][skillName].level = utils.calculateLevel(skillsCache[source][skillName].xp, skillName)
end

exports('addXp', skills.addXp)

---@param source number
---@param skillName string
---@param xpAmount number
function skills.removeXp(source, skillName, xpAmount)
    local charId = framework.getCharacterIdentifier(source)
    db.removeXp(charId, skillName, xpAmount)
    skillsCache[source][skillName].xp = skillsCache[source][skillName].xp - xpAmount
    skillsCache[source][skillName].level = utils.calculateLevel(skillsCache[source][skillName].xp, skillName)
end

exports('removeXp', skills.removeXp)

---@param source number
---@param skillName string
function skills.getSkillLevel(source, skillName)
    if not skillsCache[source] or not skillsCache[source][skillName] then
        return 0
    end
    local skillData = skillsCache[source][skillName]
    return skillData.level
end

exports('getSkillLevel', skills.getSkillLevel)

---@param source number
---@param skillName string
function skills.getSkillXp(source, skillName)
    if not skillsCache[source] or not skillsCache[source][skillName] then
        return 0
    end
    return skillsCache[source][skillName].xp
end

exports('getSkillXp', skills.getSkillXp)

---@param source number
---@param skillName string
---@param level number
function skills.setSkillLevel(source, skillName, level)
    local charId = framework.getCharacterIdentifier(source)
    local skillConfig = conf.Skills[skillName]
    if not skillConfig then return end

    local xpAmount = skillConfig.baseXp * (skillConfig.nextLevelMultiplier ^ (level - 1))
    db.setXp(charId, skillName, xpAmount)
    skillsCache[source][skillName].xp = xpAmount
    skillsCache[source][skillName].level = level
end

exports('setSkillLevel', skills.setSkillLevel)

---@param source number
---@param skillName string
function skills.resetSkill(source, skillName)
    local charId = framework.getCharacterIdentifier(source)
    db.resetSkill(charId, skillName)
    skillsCache[source][skillName] = { xp = 0, level = 1 }
end

exports('resetSkill', skills.resetSkill)

---@param source number
function skills.getAllSkills(source)
    if not skillsCache[source] then return {} end
    return skillsCache[source]
end

exports('getAllSkills', skills.getAllSkills)

---@param source number
function skills.hasSkill(source, skillName)
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
        for i = 1, #playerSkills do
            local pSkillData = playerSkills[i]
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
