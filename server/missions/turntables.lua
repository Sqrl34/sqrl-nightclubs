QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('nightclubs:server:equiptmentGetMissionData', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local club = MySQL.prepare.await('SELECT `metadata` FROM `nightclubs` WHERE `citizenid` = ?',
        { Player.PlayerData.citizenid })
    TriggerClientEvent('nightclubs:client:equiptmentStartMission', src, club)
end)

RegisterNetEvent('nightclubs:server:effectSetData', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local club = MySQL.prepare.await('SELECT `metadata` FROM `nightclubs` WHERE `citizenid` = ?',
        { Player.PlayerData.citizenid })
    local tempData = json.decode(club)
    if tempData['turntables'] == tostring(nil) then
        tempData['turntables'] = 'Int01_ba_dj01'
    end
    if tempData['droplets'] == tostring(nil) then
        tempData['droplets'] = 'DJ_01_Lights_01'
    end
    if tempData['speakers'] == tostring(nil) then
        tempData['speakers'] = 'Int01_ba_equipment_setup'
    end
    local rtrn = json.encode(tempData)
    local id = MySQL.update.await('UPDATE nightclubs SET metadata = ? WHERE citizenid = ?', {
        rtrn, Player.PlayerData.citizenid
    })
end)