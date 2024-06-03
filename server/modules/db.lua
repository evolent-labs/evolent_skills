local MySQL = MySQL
local db = {}

---@param charId string
---@return table
function db.getPlayerSkills(charId)
    return MySQL.query.await('SELECT skill_name, xp FROM player_skills WHERE char_id = ?', { charId })
end

---@param charId string
---@param skillName string
function db.insertNewPlayerSkill(charId, skillName)
    MySQL.prepare('INSERT INTO player_skills (char_id, skill_name) VALUES (?, ?)', { charId, skillName })
end

---@param charId string
---@param skillName string
---@param xpAmount number
function db.addXp(charId, skillName, xpAmount)
    MySQL.prepare('UPDATE player_skills SET xp = xp + ? WHERE char_id = ? AND skill_name = ?', { xpAmount, charId, skillName })
end

---@param charId string
---@param skillName string
---@param xpAmount number
function db.removeXp(charId, skillName, xpAmount)
    MySQL.prepare('UPDATE player_skills SET xp = GREATEST(xp - ?, 0) WHERE char_id = ? AND skill_name = ?', { xpAmount, charId, skillName })
end

---@param charId string
---@param skillName string
---@param xpAmount number
function db.setXp(charId, skillName, xpAmount)
    MySQL.prepare('UPDATE player_skills SET xp = ? WHERE char_id = ? AND skill_name = ?', { xpAmount, charId, skillName })
end

---@param charId string
---@param skillName string
function db.resetSkill(charId, skillName)
    MySQL.prepare('UPDATE player_skills SET xp = 0 WHERE char_id = ? AND skill_name = ?', { charId, skillName })
end

function db.ensurePlayerSkillsTable()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS player_skills (
            char_id VARCHAR(255) NOT NULL,
            skill_name VARCHAR(100) NOT NULL,
            xp INT DEFAULT 0,
            PRIMARY KEY (char_id, skill_name)
        )
    ]])
end

return db
