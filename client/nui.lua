local conf = require 'config'

local visible = false

RegisterCommand('skills', function()
    visible = not visible

    local data = {
        visible = visible,
        playerSkills = visible and lib.callback.await('evolent_skills:server:getSkills') or nil
    }

    SendNUIMessage({
        action = 'showSkills',
        data = data
    })

    SetNuiFocus(visible, visible)
end, false)

RegisterNUICallback('hideSkills', function(_, cb)
    visible = false
    SetNuiFocus(false, false)
    cb({})
end)

RegisterKeyMapping('skills', 'Show Skills View', 'keyboard', conf.UIHotkey)
