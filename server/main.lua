QBCore = exports['qb-core']:GetCoreObject()
local inside = {}

local function getData(citizenid)
    local data = MySQL.Sync.prepare('SELECT * FROM nightclubs where citizenid = ?', { citizenid })
    return data
end

local function sendToClub(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    inside[#inside+1] = src
    TriggerEvent('nightclubs:server:sendBucket', source, source)
    Wait(1000)
    SetEntityCoords(src, Config.ClubCoords.x, Config.ClubCoords.y, Config.ClubCoords.z, false, false, false, false)
    TriggerClientEvent('nightclubs:client:addinfo', src, getData(Player.PlayerData.citizenid))
    Wait(1000)
    TriggerClientEvent('nightclubs:client:loadProps', src, getData(Player.PlayerData.citizenid))

end

RegisterNetEvent('nightclubs:server:sendinside', function()
    TriggerClientEvent('nightclubs:client:inside', source, inside)
end)


RegisterNetEvent('nightclubs:server:getBucket', function()
    TriggerClientEvent('nightclubs:client:getBucket', source, GetPlayerRoutingBucket(source))
end)
RegisterNetEvent('nightclubs:server:returnEnterance', function()
    for k, v in pairs(inside) do
        if source == inside[k] then
            inside[k] = nil
        end
    end
    SetPlayerRoutingBucket(source, 0)
    SetEntityCoords(source, Config.Enterance['Blip'].coords.x, Config.Enterance['Blip'].coords.y,
        Config.Enterance['Blip'].coords.z, false, false, false, false)
end)

RegisterNetEvent('nightclubs:server:sendBucket', function(source, bucket)
    SetPlayerRoutingBucket(source, tonumber(bucket))
end)

RegisterNetEvent('nightclubs:server:buyObj', function(ClubData, dataType, category, name)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.money.cash >= Config.Price['Upgrades'][category][name].price then
        Player.Functions.RemoveMoney('cash', Config.Price['Upgrades'][category][name].price, "Upgraded Club")
        ClubData.Metadata[dataType] = Config.Price['Upgrades'][category][name].name
        local data = json.encode(ClubData.Metadata)
        local id = MySQL.update.await('UPDATE nightclubs SET metadata = ? WHERE citizenid = ?', {
            data, Player.PlayerData.citizenid
        })
        TriggerClientEvent('nightclubs:client:removeipl', src)
        Wait(10)
        TriggerClientEvent('nightclubs:client:addinfo', src, getData(Player.PlayerData.citizenid))
        TriggerClientEvent('nightclubs:client:loadProps', src, getData(Player.PlayerData.citizenid))
        TriggerClientEvent('QBCore:Notify', src, 'Upgraded the club', 'success')
    elseif Player.PlayerData.money.bank >= Config.Price['Upgrades'][category][name].price then
        Player.Functions.RemoveMoney('bank', Config.Price['Upgrades'][category][name].price, "Upgraded Club")
        ClubData.Metadata[dataType] = Config.Price['Upgrades'][category][name].name
        local data = json.encode(ClubData.Metadata)
        local id = MySQL.update.await('UPDATE nightclubs SET metadata = ? WHERE citizenid = ?', {
            data, Player.PlayerData.citizenid
        })
        TriggerClientEvent('nightclubs:client:removeipl', src)
        Wait(10)
        TriggerClientEvent('nightclubs:client:addinfo', src, getData(Player.PlayerData.citizenid))
        TriggerClientEvent('nightclubs:client:loadProps', src, getData(Player.PlayerData.citizenid))
        TriggerClientEvent('QBCore:Notify', src, 'Upgraded the club', 'success')
    else
        TriggerClientEvent('QBCore:Notify', src, 'Not enough funds', 'error')
    end
end)



RegisterNetEvent('nightclubs:server:buy', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ClubData = {}
    local Missions = {}
    local Employees = {}

    ClubData['name'] = 'Int01_ba_clubname_01'
    ClubData['style'] = 'Int01_ba_Style01'
    ClubData['speakers'] = 'nil'
    ClubData['podium'] = 'nil'
    ClubData['security'] = 'nil'
    ClubData['turntables'] = 'nil'
    ClubData['droplets'] = 'nil'
    ClubData['neons'] = 'nil'
    ClubData['bands'] = 'nil'
    ClubData['lasers'] = 'nil'
    ClubData['bar'] = 'Int01_ba_bar_content'
    ClubData['booze'] = 'nil'
    ClubData['worklamps'] = 'Int01_ba_Worklamps'
    ClubData['truck'] = 'Int01_ba_deliverytruck'

    Missions['posters'] = '1'
    Missions['food'] = '50'

    Employees['dancers'] = '0'
    Employees['dj'] = '0'
    Employees['tenders'] = '0'


    if Player.PlayerData.money.cash >= Config.Price['Base'] then
        TriggerClientEvent('QBCore:Notify', src, 'Bought the club in cash', 'success')
        Player.Functions.RemoveMoney('cash', Config.Price['Base'], "Bought Club")
        local data = json.encode(ClubData)
        local mission = json.encode(Missions)
        local employee = json.encode(Employees)
        local id = MySQL.insert('INSERT INTO `nightclubs` (citizenid, metadata, missions, employee) VALUES (?, ?, ?, ?)',
            { Player.PlayerData.citizenid, data, mission, employee })
        sendToClub(source)
        TriggerClientEvent('nightclubs:client:sendMail', src)
    elseif Player.PlayerData.money.bank >= Config.Price['Base'] then
        TriggerClientEvent('QBCore:Notify', src, 'Bought the club in bank', 'success')
        Player.Functions.RemoveMoney('bank', Config.Price['Base'], "Bought Club")
        local data = json.encode(ClubData)
        local mission = json.encode(Missions)
        local employee = json.encode(Employees)
        local id = MySQL.insert('INSERT INTO `nightclubs` (citizenid, metadata, missions, employee) VALUES (?, ?, ?, ?)',
            { Player.PlayerData.citizenid, data, mission, employee })
        sendToClub(source)
        TriggerClientEvent('nightclubs:client:sendMail', src)
    else
        TriggerClientEvent('QBCore:Notify', src,
            'You do not have the sufficient funds to buy a nightclub in bank or cash', 'error')
    end
end)

RegisterNetEvent('nightclubs:server:create', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    sendToClub(src)
end)

RegisterNetEvent('nightclubs:server:getinfo', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local data = getData(Player.PlayerData.citizenid)
    TriggerClientEvent('nightclubs:client:addinfo', src, data)
end)


RegisterNetEvent('nightclubs:server:employeesFunction', function(type, hire)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local data = getData(Player.PlayerData.citizenid)
    local temp = json.decode(data.employee)
    if hire then
        temp[type] = tonumber(temp[type]) + 1
    else
        temp[type] = tonumber(temp[type]) - 1
    end
    local id = MySQL.update.await('UPDATE nightclubs SET employee = ? WHERE citizenid = ?', {
        json.encode(temp), Player.PlayerData.citizenid
    })
    TriggerClientEvent('nightclubs:client:update', src)
end)
-- need to do
RegisterNetEvent('nightclubs:server:handouts', function(ClubData, Employee, percentage)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local total = 0.0
    if percentage > 1 then
        return
    end
    total = total + percentage * #Config.PedSpawns.locations * Config.Earnings.admission
    total = total + Config.FoodMission.remove * Config.Earnings.food
    total = total - Config.Employee.dj.price * Config.Employee.dj.hoursworked * tonumber(Employee['dj'])
    total = total - Config.Employee.dancers.price * Config.Employee.dancers.hoursworked * tonumber(Employee['dancers'])
    total = total - Config.Employee.tenders.price * Config.Employee.tenders.hoursworked * tonumber(Employee['tenders'])
    for k,v in pairs(Config.Earnings.upgrades) do
        if Config.Earnings.upgrades[k].bonus then
            for m, v in pairs(Config.Earnings.upgrades[k].types) do
                if Config.Earnings.upgrades[k].types[m].name == ClubData[Config.Earnings.upgrades[k].name] then
                    total = total + Config.Earnings.upgrades[k].types[m].amount
                end
            end
        end
    end

    if total > 0 then
        Player.Functions.AddMoney('bank', total, "Nightclub Earn")
        TriggerClientEvent('QBCore:Notify', src, 'Nightclub Earnings', 'success')
    elseif total < 0 then
        Player.Functions.RemoveMoney('bank', math.abs(total), "Nightclub Fail")
        TriggerClientEvent('QBCore:Notify', src, 'Nightclub Earnings went negative', 'error')
    end
end)