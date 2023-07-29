QBCore = exports['qb-core']:GetCoreObject()
local blips = {}
local zones = {}
local obj = {}
local count = 0
local base = 0
local effectProgress = false
local controlListen

local function removeStuff(k)
    RemoveBlip(blips[k])
    zones[k]:destroy()
    DeleteObject(obj[k])
end

local function loading(k)
    if lib.progressBar({
            duration = 3000,
            label = 'Taking Equiptment',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = 'random@domestic',
                clip = 'pickup_low',
            },
            prop = {},
        }) then
        removeStuff(k)
        count = count + 1
        Wait(1000)
        if base == count then
            TriggerServerEvent('nightclubs:server:effectSetData')
            QBCore.Functions.Notify('All the equiptment has been picked up', "success")
            MISSION_PROGRESS =  false
            zones = nil
            blips = nil
            count = 0
            effectProgress = false
        end
    else
    end
end

local function createStuff(num)
    RequestModel('pbus2')
    while not HasModelLoaded('pbus2') do
        Citizen.Wait(1)
    end

    obj[num] = CreateObject('pbus2', Config.EffectsMission.place[num].coords.x, Config.EffectsMission.place[num].coords.y, Config.EffectsMission.place[num].coords.z - 1.5, true, true, false)
    SetEntityAsMissionEntity(obj[num], true, true)
    SetEntityHeading(obj[num], Config.EffectsMission.place[num].coords.w)
    FreezeEntityPosition(obj[num], true)

    blips[num] = AddBlipForCoord(Config.EffectsMission.place[num].coords.x, Config.EffectsMission.place[num].coords.y,
        Config.EffectsMission.place[num].coords.z)
    SetBlipColour(blips[num], Config.EffectsMission.blip.color)
    SetBlipSprite(blips[num], Config.PosterMission.blip.sprite)
    SetBlipScale(blips[num], .6)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.PosterMission.blip.name .. '-' .. Config.EffectsMission.place[num].name)
    EndTextCommandSetBlipName(blips[num])

    zones[num]= BoxZone:Create(vector3(Config.EffectsMission.place[num].coords.x, Config.EffectsMission.place[num].coords.y, Config.EffectsMission.place[num].coords.z), 12, 6, {
        name="box_zone",
        heading = Config.EffectsMission.place[num].coords.w,
        minZ = Config.EffectsMission.place[num].coords.z - 3,
        maxZ = Config.EffectsMission.place[num].coords.z + 3,
        offset={0.0, 0.0, 0.0},
        scale={1.0, 1.0, 1.0},
        debugPoly=false,
    })

    zones[num]:onPlayerInOut(function(isPointInside, point)
        if isPointInside then
            controlListen = true
            while controlListen and isPointInside do
                lib.showTextUI('[E] - Pick up equiptment')
                if IsControlJustReleased(0, 38) then
                    lib.hideTextUI()
                    loading(num)
                    controlListen = false
                end
                Wait(1)
            end
        else
            lib.hideTextUI()
        end
    end)
end

RegisterNetEvent('nightclubs:client:equiptmentStartMission', function(data)
    local tempData = json.decode(data) 
    if ((tempData['turntables'] ~= tostring(nil)) and (tempData['droplets'] ~= tostring(nil)) and (tempData['speakers'] ~= tostring(nil))) then
        QBCore.Functions.Notify('You aready have lights, turntables, and speakers', "error")
        return
    else
        MISSION_PROGRESS = true
        effectProgress = true
        TriggerServerEvent('nightclubs:server:returnEnterance')
        for k, v in pairs(Config.EffectsMission.place) do
            QBCore.Functions.Notify('Go to the marked locations and pick up items', "primary")
            if tempData[Config.EffectsMission.place[k].name] == tostring(nil) then
                base = base + 1
                createStuff(k)
            end
        end
    end
end)
