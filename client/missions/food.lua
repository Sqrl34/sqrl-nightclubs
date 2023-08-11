QBCore = exports['qb-core']:GetCoreObject()
local blips = {}
local zones = {}
local controlListen = false
local count = 0
local foodProgress = false
local data = nil
local setdata

local function removeClose(k)
    RemoveBlip(blips[k])
    zones[k]:destroy()
end

function getFood()
    print(setdata)
    if data == nil then
        TriggerServerEvent('nightclubs:server:foodJoinServer')
        Wait(7000)
        return data['food']
    end
    return data['food']
end

local function loading(k)
    if lib.progressBar({
            duration = 3000,
            label = 'Picking up food and drinks',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = 'random@domestic',
                clip = 'pickup_low'
            },
            prop = {},
        }) then
        removeClose(k)
        count = count + 1
        Wait(1000)
        if #blips == count then
            QBCore.Functions.Notify('All the food and drinks have been picked up', "success")
            data['food'] = Config.FoodMission.max
            MISSION_PROGRESS = false
            --zones = nil
            --blips = nil
            count = 0
            foodProgress = false
        end
    else
    end
end

RegisterNetEvent('nightclubs:client:foodReplinish', function()
    MISSION_PROGRESS = true
    for k, v in pairs(Config.FoodMission.locations) do
        blips[k] = AddBlipForCoord(Config.FoodMission.locations[k].coords.x,
            Config.FoodMission.locations[k].coords.y,
            Config.FoodMission.locations[k].coords.z)
        SetBlipColour(blips[k], Config.FoodMission.blip.color)
        SetBlipSprite(blips[k], Config.FoodMission.blip.sprite)
        SetBlipScale(blips[k], .6)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.FoodMission.blip.name)
        EndTextCommandSetBlipName(blips[k])

        zones[k] = BoxZone:Create(
            vector3(Config.FoodMission.locations[k].coords.x,
                Config.FoodMission.locations[k].coords.y,
                Config.FoodMission.locations[k].coords.z), 4, 4, {
                name = "box_zone",
                offset = { 0.0, 0.0, 0.0 },
                scale = { 1.0, 1.0, 1.0 },
                heading = Config.FoodMission.locations[k].coords.w,
                maxZ = Config.FoodMission.locations[k].coords.z + 2,
                min = Config.FoodMission.locations[k].coords.z - 2,
                debugPoly = false,
            })

        zones[k]:onPlayerInOut(function(isPointInside, point)
            if isPointInside then
                controlListen = true
                while controlListen and isPointInside do
                    lib.showTextUI('[E] - Pick Up Food And Drinks')
                    if IsControlJustReleased(0, 38) then
                        lib.hideTextUI()
                        loading(k)
                        controlListen = false
                    end
                    Wait(1)
                end
            else
                lib.hideTextUI()
            end
        end)
    end
end)

RegisterNetEvent('nightclubs:client:foodSetUp', function(dataa)
    data = dataa
    if tonumber(data['food']) ~= Config.FoodMission.max then
        if not MISSION_PROGRESS then
            QBCore.Functions.Notify('Pickup all the food at the given locations', "success")
            TriggerEvent('nightclubs:client:foodReplinish')
        else
            QBCore.Functions.Notify('You already have a mission going', "error")
        end
    else
        QBCore.Functions.Notify('YUou already have enough food', "error")
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    TriggerServerEvent('nightclubs:server:foodJoinServer')
end)

RegisterNetEvent('nightclubs:client:foodJoinSet', function(d)
    Wait(5000)
    data = d
    if data == nil then
        setdata = false
    elseif data ~= nil then
        setdata = true
    end
end)

local ranThread = false
CreateThread(function()
    while true do
        if CLUB_OWNED then
            if setdata then
                if data['food'] ~= tostring(nil) then
                    if GetClockHours() == Config.FoodMission.time and not ranThread then
                        ranThread = true
                        local tmp = tonumber(data['food']) - Config.FoodMission.remove
                        if tmp < Config.FoodMission.min then
                            QBCore.Functions.Notify('You are running low on nightclub food, replinish it', "error")
                        end
                        data['food'] = tmp
                        TriggerServerEvent('nightclubs:server:foodSet', data)
                    end
                end
            end
        end
        if GetClockHours() == 0 then
            ranThread = false
        end
        Wait(10000)
    end
end)
