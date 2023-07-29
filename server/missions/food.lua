QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('nightclubs:server:foodGetData', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `citizenid` = ?',
        { Player.PlayerData.citizenid })
    local tmp = json.decode(data)
    TriggerClientEvent('nightclubs:client:foodSetUp', src, tmp)
end)

RegisterNetEvent('nightclubs:server:foodSet', function(dataa)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tmp = json.encode(dataa)

    local id = MySQL.update.await('UPDATE nightclubs SET missions = ? WHERE citizenid = ?', {
        tmp, Player.PlayerData.citizenid
    })
end)

RegisterNetEvent('nightclubs:server:foodJoinServer', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `citizenid` = ?',
        { Player.PlayerData.citizenid })
    local tmp = json.decode(data)
    TriggerClientEvent('nightclubs:client:foodJoinSet', src, tmp)
end)

RegisterNetEvent('nightclubs:server:buy', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `citizenid` = ?',
        { Player.PlayerData.citizenid })
    local tmp = json.decode(data)
    TriggerClientEvent('nightclubs:client:foodJoinSet', src, tmp)
end)