local isRolling = false
local isMenuOpen = false
local activeRolls = {}
local txdName = "ty_dice"

CreateThread(function()
    RequestStreamedTextureDict(txdName, false)
    while not HasStreamedTextureDictLoaded(txdName) do
        Wait(50)
    end
end)

RegisterNetEvent('ty-dice:client:openMenu', function()
    if isRolling or isMenuOpen then return end
    isMenuOpen = true
    
    SendNUIMessage({ 
        action = "openMenu",
        locales = {
            title = _U('menu_title'),
            amount = _U('amount'),
            mode = _U('mode'),
            roll = _U('roll'),
            cancel = _U('cancel'),
            desc_amount = _U('desc_amount'),
            desc_mode = _U('desc_mode'),
            desc_roll = _U('desc_roll'),
            desc_cancel = _U('desc_cancel'),
            footer_nav = _U('footer_nav'),
            footer_change = _U('footer_change'),
            footer_confirm = _U('footer_confirm'),
            footer_back = _U('footer_back')
        }
    })

    -- Input Loop 
    CreateThread(function()
        while isMenuOpen do
            Wait(0)
            DisableControlAction(0, 172, true) -- UP
            DisableControlAction(0, 173, true) -- DOWN
            DisableControlAction(0, 174, true) -- LEFT
            DisableControlAction(0, 175, true) -- RIGHT
            DisableControlAction(0, 191, true) -- ENTER
            DisableControlAction(0, 177, true) -- BACKSPACE
            DisableControlAction(0, 200, true) -- ESC

            if IsDisabledControlJustPressed(0, 172) then SendNUIMessage({ action = "key", key = "up" }) end
            if IsDisabledControlJustPressed(0, 173) then SendNUIMessage({ action = "key", key = "down" }) end
            if IsDisabledControlJustPressed(0, 174) then SendNUIMessage({ action = "key", key = "left" }) end
            if IsDisabledControlJustPressed(0, 175) then SendNUIMessage({ action = "key", key = "right" }) end
            if IsDisabledControlJustPressed(0, 191) then SendNUIMessage({ action = "key", key = "enter" }) end
            if IsDisabledControlJustPressed(0, 177) or IsDisabledControlJustPressed(0, 200) then 
                SendNUIMessage({ action = "key", key = "back" }) 
            end
        end
    end)
end)

RegisterNUICallback('closeMenu', function(data, cb)
    isMenuOpen = false
    cb('ok')
end)

RegisterNUICallback('rollDice', function(data, cb)
    isMenuOpen = false
    cb('ok')
    
    local amount = tonumber(data.amount) or 1
    local calcSum = data.calcSum
    
    if isRolling then return end
    isRolling = true

    CreateThread(function()
        RequestAnimDict(Config.AnimDict)
        while not HasAnimDictLoaded(Config.AnimDict) do Wait(10) end

        TaskPlayAnim(PlayerPedId(), Config.AnimDict, Config.AnimName, 8.0, -8.0, -1, 49, 0, false, false, false)
        Wait(Config.AnimDuration)
        ClearPedTasks(PlayerPedId())

        local rolls = {}
        for i = 1, amount do table.insert(rolls, math.random(1, 6)) end

        TriggerServerEvent('ty-dice:server:ShareRoll', rolls, calcSum)
        isRolling = false
    end)
end)

RegisterNetEvent('ty-dice:client:ShowRoll', function(sourceId, rolls, sum)
    activeRolls[sourceId] = { rolls = rolls, sum = sum, endTime = GetGameTimer() + Config.DisplayTime }
end)

-- Rendering Loop with Aspect Ratio Stretch Fix
CreateThread(function()
    while true do
        local sleep = 500
        local currentTimer = GetGameTimer()
        local hasActiveRolls = false

        for k, v in pairs(activeRolls) do
            if currentTimer > v.endTime then activeRolls[k] = nil else hasActiveRolls = true end
        end

        if hasActiveRolls then
            sleep = 0
            local localPed = PlayerPedId()
            local localCoords = GetEntityCoords(localPed)
            
            -- Aspect Ratio Calculation to fix stretching!
            local screenW, screenH = GetActiveScreenResolution()
            local aspectRatio = screenW / screenH
            local spriteW = Config.BaseSpriteSize
            local spriteH = spriteW * aspectRatio 

            for targetServerId, data in pairs(activeRolls) do
                local targetPlayer = GetPlayerFromServerId(targetServerId)
                if targetPlayer ~= -1 then
                    local targetPed = GetPlayerPed(targetPlayer)
                    if DoesEntityExist(targetPed) then
                        local targetCoords = GetEntityCoords(targetPed)
                        local distance = #(localCoords - targetCoords)

                        if distance <= Config.DrawDistance and HasEntityClearLosToEntity(localPed, targetPed, 17) then
                            local boneCoords = GetPedBoneCoords(targetPed, 12844, 0.0, 0.0, 0.0) 
                            local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(boneCoords.x, boneCoords.y, boneCoords.z + 0.45)

                            if onScreen then
                                local count = #data.rolls
                                local spacing = spriteW + 0.005

                                for i = 1, count do
                                    local offsetX = (i - (count + 1) / 2) * spacing
                                    DrawSprite(txdName, tostring(data.rolls[i]), screenX + offsetX, screenY, spriteW, spriteH, 0.0, 255, 255, 255, 255)
                                end

                                if data.sum then
                                    SetTextFont(4)
                                    SetTextScale(0.35, 0.35)
                                    SetTextColour(255, 255, 255, 255)
                                    SetTextOutline()
                                    SetTextCentre(true)
                                    SetTextEntry("STRING")
                                    AddTextComponentString(_U('total_sum') .. tostring(data.sum))
                                    DrawText(screenX, screenY + spriteH / 2 + 0.005)
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)