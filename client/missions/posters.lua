QBCore = exports['qb-core']:GetCoreObject()
local blips = {}
local zones = {}
local data
local controlListen = false
local count = 0
local foodProgress = false

local function removeClose(k)
    RemoveBlip(blips[k])
    zones[k]:destroy()
end

local function loading(k)
    if lib.progressBar({
            duration = 3000,
            label = 'Collecting Goods',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                scenario = 'WORLD_HUMAN_HAMMERING',
            },
            prop = {},
        }) then
        removeClose(k)
        count = count + 1
        Wait(1000)
        if #blips == count then
            TriggerServerEvent('nightclubs:server:posterSetData')
            QBCore.Functions.Notify('All food has been acquired', "success")
            MISSION_PROGRESS =  false
            zones = nil
            blips = nil
            count = 0
            foodProgress = false
        end
    else
    end
end

local function createBase(num)
    for k, v in pairs(Config.PosterMission.place[tonumber(num)].location) do
        blips[k] = AddBlipForCoord(Config.PosterMission.place[tonumber(num)].location[k].coords.x,
            Config.PosterMission.place[tonumber(num)].location[k].coords.y,
            Config.PosterMission.place[tonumber(num)].location[k].coords.z)
        SetBlipColour(blips[k], Config.PosterMission.blip.color)
        SetBlipSprite(blips[k], Config.PosterMission.blip.sprite)
        SetBlipScale(blips[k], .6)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.PosterMission.blip.name)
        EndTextCommandSetBlipName(blips[k])

        zones[k] = BoxZone:Create(
            vector3(Config.PosterMission.place[tonumber(num)].location[k].coords.x,
                Config.PosterMission.place[tonumber(num)].location[k].coords.y,
                Config.PosterMission.place[tonumber(num)].location[k].coords.z), 2, 2, {
                name = "box_zone",
                offset = { 0.0, 0.0, 0.0 },
                scale = { 1.0, 1.0, 1.0 },
                heading = Config.PosterMission.place[tonumber(num)].location[k].coords.w,
                maxZ = Config.PosterMission.place[tonumber(num)].location[k].coords.z + 2,
                min = Config.PosterMission.place[tonumber(num)].location[k].coords.z - 2,
                debugPoly = false,
            })

        zones[k]:onPlayerInOut(function(isPointInside, point)
            if isPointInside then
                controlListen = true
                while controlListen and isPointInside do
                    lib.showTextUI('[E] - Hang Poster')
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
end


RegisterNetEvent('nightclubs:client:posterGetData', function(missionData)
    data = json.decode(missionData)
    if tonumber(data['posters']) < 4 then
        if not MISSION_PROGRESS then
            foodProgress = true
            MISSION_PROGRESS =  true
            createBase(data['posters'])
            QBCore.Functions.Notify('Head outside and hang posters on the walls', "success")
        else
            QBCore.Functions.Notify('You already have a mission going', "error")
        end
    else
        QBCore.Functions.Notify('Max amount of posters have been put up', "error")
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if foodProgress then
        for k, v in pairs(blips) do
            RemoveBlip(blips[k])
            zones[k]:destroy()
        end
        zones = nil
        blips = nil
        foodProgress = false
    end
end)