---@param skillName string
local function getSkillLevel(skillName)
    return lib.callback.await('evolent_skills:server:getSkillLevel', false, skillName)
end

exports('getSkillLevel', getSkillLevel)

---@param skillName string
local function getSkillXp(skillName)
    return lib.callback.await('evolent_skills:server:getSkillXp', false, skillName)
end

exports('getSkillXp', getSkillXp)

local function getAllSkills()
    return lib.callback.await('evolent_skills:server:getAllSkills')
end

exports('getAllSkills', getAllSkills)
