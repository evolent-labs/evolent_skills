---@class Skill
---@field label string
---@field baseXp number
---@field nextLevelMultiplier number
---@field maxLevel number
---@field icon string
---@field color string

return {
    ---@type 'qb'|'qbx'|'esx'|'ox'
    Framework = 'qb',

    ---@type string
    UIHotkey = 'J',

    --- @type table<string, Skill>
    Skills = {
        driving = {
            label = 'Driving',
            baseXp = 120,
            nextLevelMultiplier = 1.4,
            maxLevel = 100,
            icon = 'fas fa-car',
            color = '#AFC1FF'
        },
        shooting = {
            label = 'Shooting',
            baseXp = 120,
            nextLevelMultiplier = 1.5,
            maxLevel = 150,
            icon = 'fa-solid fa-gun',
            color = '#ff5959'
        },
        cornerselling = {
            label = 'Cornerselling',
            baseXp = 30,
            nextLevelMultiplier = 1.8,
            maxLevel = 100,
            icon = 'fa-solid fa-pills',
            color = '#7aff81'
        }
    }
}
