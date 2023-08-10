QBCore = exports['qb-core']:GetCoreObject()
local ClubData = {}
local Employee = {}
local Missions = {}
local employeePed = {}
local civs = {}
MISSION_PROGRESS = false
CLUB_OWNED = false
local arg = {
    owned = false
}
local upgradedone = false
local bucket
local paid = false
local ownedclubforpayment = false



local function pedPercentage()
    local percentage = 0.0
    if Employee['dj'] ~= tostring(0) then
        percentage = percentage + (tonumber(Employee['dj']) * Config.PedPercentage.employee.dj)
        percentage = percentage + (tonumber(Employee['dancers']) * Config.PedPercentage.employee.dancers)
        percentage = percentage + (tonumber(Employee['tenders']) * Config.PedPercentage.employee.tenders)
        percentage = percentage + (tonumber(Missions['posters']) * Config.PedPercentage.postermission)
        if tonumber(getFood()) < Config.FoodMission.min then
            percentage = percentage + Config.PedPercentage.food
        end
    end
    return percentage
end

local function spawnPeds()
    local percentage = pedPercentage()
    local finish = math.floor(percentage * #Config.PedSpawns.locations)
    for k, v in pairs(Config.PedSpawns.locations) do
        if (finish < k) then return end
        local num1 = math.random(#Config.PedSpawns.models)
        local model = Config.PedSpawns.models[num1].hash
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local ped = CreatePed(0, model, Config.PedSpawns.locations[k].coords.x,
            Config.PedSpawns.locations[k].coords.y, Config.PedSpawns.locations[k].coords.z - 1,
            Config.PedSpawns.locations[k].coords.w, true, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        local num2 = math.random(#Config.PedSpawns.anims)

        while (not HasAnimDictLoaded(Config.PedSpawns.anims[num2].dict)) do
            RequestAnimDict(Config.PedSpawns.anims[num2].dict)
            Wait(1)
        end
        TaskPlayAnim(ped, Config.PedSpawns.anims[num2].dict, Config.PedSpawns.anims[num2].clip, 1.0, 1.0, -1, 1, 0, 0, 0)
        civs[#civs + 1] = ped
    end
end

local function spawnEmployees()
    for k, v in pairs(Config.Employee.dj.locations) do
        if k <= tonumber(Employee['dj']) then
            local model = Config.Employee.dj.model
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end

            local ped = CreatePed(0, model, Config.Employee.dj.locations[k].coords.x,
                Config.Employee.dj.locations[k].coords.y, Config.Employee.dj.locations[k].coords.z - 1,
                Config.Employee.dj.locations[k].coords.w, true, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            while (not HasAnimDictLoaded(Config.Employee.dj.animdict)) do
                RequestAnimDict(Config.Employee.dj.animdict)
                Wait(1)
            end
            TaskPlayAnim(ped, Config.Employee.dj.animdict, Config.Employee.dj.clip, 1.0, 1.0, -1, 1, 0, 0, 0)
            employeePed[#employeePed + 1] = ped
        end
    end

    for k, v in pairs(Config.Employee.dancers.locations) do
        if k <= tonumber(Employee['dancers']) then
            local model = Config.Employee.dancers.model
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end

            local ped = CreatePed(0, model, Config.Employee.dancers.locations[k].coords.x,
                Config.Employee.dancers.locations[k].coords.y, Config.Employee.dancers.locations[k].coords.z - 1,
                Config.Employee.dancers.locations[k].coords.w, true, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            while (not HasAnimDictLoaded(Config.Employee.dancers.animdict)) do
                RequestAnimDict(Config.Employee.dancers.animdict)
                Wait(1)
            end
            TaskPlayAnim(ped, Config.Employee.dancers.animdict, Config.Employee.dancers.clip, 1.0, 1.0, -1, 1, 0, 0, 0)
            employeePed[#employeePed + 1] = ped
        end
    end

    for k, v in pairs(Config.Employee.tenders.locations) do
        if k <= tonumber(Employee['tenders']) then
            local model = Config.Employee.tenders.model
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end

            local ped = CreatePed(0, model, Config.Employee.tenders.locations[k].coords.x,
                Config.Employee.tenders.locations[k].coords.y, Config.Employee.tenders.locations[k].coords.z - 1,
                Config.Employee.tenders.locations[k].coords.w, true, true)
            FreezeEntityPosition(ped, true)
            SetEntityInvincible(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            while (not HasAnimDictLoaded(Config.Employee.tenders.animdict)) do
                RequestAnimDict(Config.Employee.tenders.animdict)
                Wait(1)
            end
            TaskPlayAnim(ped, Config.Employee.tenders.animdict, Config.Employee.tenders.clip, 1.0, 1.0, -1, 1, 0, 0, 0)
            employeePed[#employeePed + 1] = ped
        end
    end
end

local function removeEmployee()
    for k, v in pairs(employeePed) do
        DeletePed(employeePed[k])
    end
end

local function removePed()
    for k, v in pairs(civs) do
        DeletePed(civs[k])
    end
end

RegisterNetEvent('nightclubs:client:sendMail', function()
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = 'Tony',
        subject = 'New Night Club',
        message = 'Congrats on the new club. Here is some info, hed into the owners office by the computer to check all of the options to hire employees, get food, and upgrde equiptment. This industry can be very lucriticve. Best of luck, Tony',
    })
end)

RegisterNetEvent('nightclubs:client:loadProps', function(props)
    TriggerEvent('nightclubs:client:removeipl')
    local tempData = json.decode(props.metadata)
    CLUB_OWNED = true

    RequestIpl('ba_int_placement_ba_interior_0_dlc_int_01_ba_milo_')
    --name
    ActivateInteriorEntitySet(271617, tostring(tempData['name']))
    --style
    ActivateInteriorEntitySet(271617, tempData['style'])
    --podium
    if tempData['podium'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['podium'])
    end
    -- security
    if tempData['security'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['security'])
    end
    -- turntables
    if tempData['turntables'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['turntables'])
    end
    --droplets
    if tempData['droplets'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['droplets'])
    end
    --neons
    if tempData['neons'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['neons'])
    end
    --bands
    if tempData['bands'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['bands'])
    end
    --lasers
    if tempData['lasers'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['lasers'])
    end
    --bar
    if tempData['bar'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['bar'])
    end
    --booze
    if tempData['booze'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['booze'])
    end
    --worklamps
    -- if tempData['worklamps'] ~= nil then
    --     ActivateInteriorEntitySet(271617, tempData['worklamps'])
    -- end
    --truck
    if tempData['truck'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['truck'])
    end
    if not upgradedone then
        UPGRADES = BoxZone:Create(vector3(-1618.41, -3011.99, -75.21), 4, 4, {
            name = "upgrades",
            maxZ = -75.41 + 4,
            minZ = -75.41 - 4,
            heading = 50,
            debugPoly = false
        })
        upgradedone = true
    end

    spawnEmployees()
    Wait(100)
    spawnPeds()
    Wait(3000)
    TriggerEvent('nightclubs:client:update')
    Wait(1000)
    TriggerServerEvent('nightclubs:server:getBucket')
    Wait(3000)

    UPGRADES:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            if GetPlayerServerId(PlayerId()) == bucket then
                TriggerEvent('nightclubs:client:bossMenu', ClubData, Employee)
            end
        end
    end)
end)

RegisterNetEvent('nightclubs:client:getBucket', function(bucketT)
    bucket = bucketT
end)

local firstRan  = true
RegisterNetEvent('nightclubs:client:removeipl', function()
    RemoveIpl('ba_int_placement_ba_interior_0_dlc_int_01_ba_milo_')
    -- Names
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_01')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_02')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_03')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_04')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_05')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_06')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_07')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_08')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_clubname_09')
    -- Styles
    DeactivateInteriorEntitySet(271617, 'Int01_ba_Style01')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_Style02')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_Style03')
    -- Podium
    DeactivateInteriorEntitySet(271617, 'Int01_ba_style01_podium')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_style02_podium')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_style03_podium')
    -- Speakers
    DeactivateInteriorEntitySet(271617, 'Int01_ba_equipment_setup')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_equipment_setup')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_equipment_upgrade')
    -- Security
    DeactivateInteriorEntitySet(271617, 'Int01_ba_security_upgrade')
    -- Turntables
    DeactivateInteriorEntitySet(271617, 'Int01_ba_dj01')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_dj02')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_dj03')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_dj04')
    -- Lights
    DeactivateInteriorEntitySet(271617, 'DJ_01_Lights_01')
    DeactivateInteriorEntitySet(271617, 'DJ_02_Lights_01')
    DeactivateInteriorEntitySet(271617, 'DJ_03_Lights_01')
    DeactivateInteriorEntitySet(271617, 'DJ_04_Lights_01')

    DeactivateInteriorEntitySet(271617, 'DJ_01_Lights_02')
    DeactivateInteriorEntitySet(271617, 'DJ_02_Lights_02')
    DeactivateInteriorEntitySet(271617, 'DJ_03_Lights_02')
    DeactivateInteriorEntitySet(271617, 'DJ_04_Lights_02')

    DeactivateInteriorEntitySet(271617, 'DJ_01_Lights_03')
    DeactivateInteriorEntitySet(271617, 'DJ_02_Lights_03')
    DeactivateInteriorEntitySet(271617, 'DJ_03_Lights_03')
    DeactivateInteriorEntitySet(271617, 'DJ_04_Lights_03')

    DeactivateInteriorEntitySet(271617, 'DJ_01_Lights_04')
    DeactivateInteriorEntitySet(271617, 'DJ_02_Lights_04')
    DeactivateInteriorEntitySet(271617, 'DJ_03_Lights_04')
    DeactivateInteriorEntitySet(271617, 'DJ_04_Lights_04')

    -- Bar
    DeactivateInteriorEntitySet(271617, 'Int01_ba_bar_content')

    -- Booze
    DeactivateInteriorEntitySet(271617, 'Int01_ba_booze_01')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_booze_02')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_booze_03')

    DeactivateInteriorEntitySet(271617, 'Int01_ba_Worklamps')
    DeactivateInteriorEntitySet(271617, 'Int01_ba_deliverytruck')

    removeEmployee()
    removePed()
    if not firstRan then
        UPGRADES:destroy()
    end
    firstRan = false
    upgradedone = false
end)

RegisterNetEvent('nightclubs:client:addinfo', function(data)
    if data == nil then
        arg.owned = false
        CLUB_OWNED = false
    else
        arg.owned = true
        CLUB_OWNED =  true
        ownedclubforpayment = true
        ClubData.Metadata = json.decode(data.metadata)
        Employee = json.decode(data.employee)
        Missions = json.decode(data.missions)
    end
end)

RegisterNetEvent('nightclubs:client:update', function()
    TriggerServerEvent('nightclubs:server:getinfo')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerEvent('nightclubs:client:update')
end)




CreateThread(function()
    local enterance = BoxZone:Create(
        vector3(Config.Enterance['Blip'].coords.x, Config.Enterance['Blip'].coords.y, Config.Enterance['Blip'].coords.z),
        5.0,
        5.0, {
            name = "enterance_zone",
            heading = Config.Enterance['Blip'].coords.w,
            minZ = Config.Enterance['Blip'].coords.z - 4,
            maxZ = Config.Enterance['Blip'].coords.z + 4,
            offset = { 0.0, 0.0, 0.0 },
            scale = { 1.0, 1.0, 1.0 },
            debugPoly = false,
        })

    enterance:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            TriggerServerEvent('nightclubs:server:getinfo')
            Wait(1000)
            TriggerEvent('nightclubs:client:enteranceMenu', arg)
        end
    end)

    local starterBlip = AddBlipForCoord(Config.Enterance['Blip'].coords.x, Config.Enterance['Blip'].coords.y,
        Config.Enterance['Blip'].coords.z)
    SetBlipColour(starterBlip, Config.Enterance['Blip'].color)
    SetBlipScale(starterBlip, .6)
    SetBlipSprite(starterBlip, Config.Enterance['Blip'].sprite)
    SetBlipDisplay(starterBlip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Enterance['Blip'].name)
    EndTextCommandSetBlipName(starterBlip)

    -- Zones
    local leave = BoxZone:Create(vector3(-1569.48, -3016.85, -74.41), 2, 3, {
        name = "leave",
        maxZ = -74.41 + 4,
        minZ = -74.41 - 4,
        heading = 0,
        debugPoly = false
    })

    leave:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            TriggerEvent('nightclubs:client:leavemenu')
        end
    end)
end)

CreateThread(function()
    while true do
        if ownedclubforpayment then
            if GetClockHours() == Config.Earnings.time and not paid then
                paid = true
                TriggerServerEvent('nightclubs:server:handouts', ClubData.Metadata, Employee, pedPercentage())
            end
        end
        Wait(10000)
        if GetClockHours() == 11 then
            paid = false
        end
    end
end)
