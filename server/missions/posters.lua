QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('nightclubs:server:posterGetMissionData', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `citizenid` = ?', { Player.PlayerData.citizenid })
    TriggerClientEvent('nightclubs:client:posterGetData', src, data)
end)

RegisterNetEvent('nightclubs:server:posterSetData', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `citizenid` = ?', { Player.PlayerData.citizenid })
    local temp = json.decode(data)
    temp['posters'] = temp['posters'] + 1
    local rtn = json.encode(temp)

    local id = MySQL.update.await('UPDATE nightclubs SET missions = ? WHERE citizenid = ?', {
        rtn, Player.PlayerData.citizenid
    })

end)