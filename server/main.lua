local QBCore, ESX = nil, nil

if Config.Framework == "auto" then
    if exports['qb-core'] then
        pcall(function() QBCore = exports['qb-core']:GetCoreObject() end)
    end
    if exports['es_extended'] then
        pcall(function() ESX = exports['es_extended']:getSharedObject() end)
    end
elseif Config.Framework == "qbcore" then
    pcall(function() QBCore = exports['qb-core']:GetCoreObject() end)
elseif Config.Framework == "esx" then
    pcall(function() ESX = exports['es_extended']:getSharedObject() end)
end

local function setupUsableItem(itemName)
    if QBCore then
        QBCore.Functions.CreateUseableItem(itemName, function(source, item)
            TriggerClientEvent('ty-dice:client:openMenu', source)
        end)
    elseif ESX then
        ESX.RegisterUsableItem(itemName, function(source)
            TriggerClientEvent('ty-dice:client:openMenu', source)
        end)
    end
end

CreateThread(function()
    Wait(1000)
    setupUsableItem(Config.DiceItem)
end)

RegisterNetEvent('ty-dice:server:ShareRoll', function(rolls, calcSum)
    local src = source
    local sum = nil
    
    if calcSum then
        sum = 0
        for i = 1, #rolls do
            sum = sum + rolls[i]
        end
    end

    TriggerClientEvent('ty-dice:client:ShowRoll', -1, src, rolls, sum)
end)