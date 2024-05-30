local skills = require 'server.modules.skills'

lib.addCommand('addxp', {
    help = 'Add XP to a player\'s skill',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id'
        },
        {
            name = 'skill',
            type = 'string',
            help = 'Name of skill'
        },
        {
            name = 'amount',
            type = 'number',
            help = 'Amount of XP to give'
        }
    },
    restricted = 'group.admin'
}, function(source, args)
    local skill = args.skill
    local skillsCache = skills.getAllSkills(source)

    if not skillsCache[skill] then
        return lib.notify(source, {
            title = 'Skills',
            description = ('Skill %s does not exist'):format(skill),
            type = 'error'
        })
    end

    skills.addXp(source, skill, args.amount)
end)

lib.addCommand('removexp', {
    help = 'Remove XP from a player\'s skill',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id'
        },
        {
            name = 'skill',
            type = 'string',
            help = 'Name of skill'
        },
        {
            name = 'amount',
            type = 'number',
            help = 'Amount of XP to remove'
        }
    },
    restricted = 'group.admin'
}, function(source, args)
    local skill = args.skill
    local skillsCache = skills.getAllSkills(source)

    if not skillsCache[skill] then
        return lib.notify(source, {
            title = 'Skills',
            description = ('Skill %s does not exist'):format(skill),
            type = 'error'
        })
    end

    skills.removeXp(source, skill, args.amount)
end)

lib.addCommand('setlevel', {
    help = 'Set level for a player\'s skill',
    params = {
        {
            name = 'target',
            type = 'playerId',
            help = 'Target player\'s server id'
        },
        {
            name = 'skill',
            type = 'string',
            help = 'Name of skill'
        },
        {
            name = 'level',
            type = 'number',
            help = 'Level to set'
        }
    },
    restricted = 'group.admin'
}, function(source, args)
    local skill = args.skill
    local skillsCache = skills.getAllSkills(source)

    if not skillsCache[skill] then
        return lib.notify(source, {
            title = 'Skills',
            description = ('Skill %s does not exist'):format(skill),
            type = 'error'
        })
    end

    skills.setSkillLevel(source, skill, args.level)
end)
