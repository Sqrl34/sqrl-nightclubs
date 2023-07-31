QBCore = exports['qb-core']:GetCoreObject()

local function checkDisabled(Employee, type, job, fire)
    if fire then
        if tonumber(Employee[type]) == 0 then
            return true
        else
            return false
        end
    else
        if tonumber(Employee[type]) < #job then
            return false
        else
            return true
        end
    end
end

local function checkdata(ClubData, dataType, category, name)
    if ClubData.Metadata[dataType] == nil then
        return false
    end
    if ClubData.Metadata[dataType] == Config.Price['Upgrades'][category][name].name then
        return true
    else
        return false
    end
end

local function buyObject(ClubData, dataType, category, name)
    TriggerServerEvent('nightclubs:server:buyObj', ClubData, dataType, category, name)
end

RegisterNetEvent('nightclubs:client:enteranceMenu', function(args)
    lib.registerContext({
        id = 'enterance_menu',
        title = 'Enterance Menu',
        options = {
            {
                title = 'Buy, Enter, or Vist a Club',
            },
            {
                title = 'Buy',
                description = 'Buy a nightclub',
                icon = 'coins',
                disabled = args.owned,
                onSelect = function()
                    TriggerServerEvent('nightclubs:server:buy')
                end,
            },
            {
                title = 'Go To Nightclub',
                description = 'Enter your night club',
                icon = 'arrow-right',
                disabled = not args.owned,
                onSelect = function()
                    TriggerServerEvent('nightclubs:server:create')
                end,

            },
            {
                title = 'Visit',
                description = 'Visit a friends club',
                icon = 'handshake',
                disavbled = false,
                onSelect = function()
                    TriggerEvent('nightclubs:client:visitClub')
                end,
            },
        }
    })

    lib.showContext('enterance_menu')
end)

RegisterNetEvent('nightclubs:client:leavemenu', function()
    lib.registerContext({
        id = 'leave_menu',
        title = 'Exit Menu',
        options = {
            {
                title = 'Leave the club',
            },
            {
                title = 'Leave',
                description = 'Leave and go back outside',
                icon = 'person-walking-arrow-right',
                onSelect = function()
                    TriggerEvent('nightclubs:client:removeipl')
                    TriggerServerEvent('nightclubs:server:returnEnterance')
                end,
            },
        }
    })

    lib.showContext('leave_menu')
end)

RegisterNetEvent('nightclubs:client:bossMenu', function(ClubData, Employee)
    lib.registerContext({
        id = 'boss_menu',
        title = 'Boss Menu',
        options = {
            {
                title = 'Edit or Upgrade the Club',
            },
            {
                title = 'Buy Upgrades',
                description = 'Buy upgrades for the club',
                icon = 'coins',
                menu = 'buy_upgrades_menu'
            },
            {
                title = 'Gain Reputation Or Do Missions',
                description = 'Buy upgrades for the club or gain reputation',
                icon = 'money-check-dollar',
                menu = 'reputation_menu'
            },
            {
                title = 'Employees',
                description = 'Hire or fire employees',
                icon = 'person-circle-check',
                menu = 'employee_menu'
            },
        }
    })

    lib.showContext('boss_menu')

    lib.registerContext({
        id = 'buy_upgrades_menu',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit or Upgrade the Club',
            },
            {
                title = 'Change Name',
                description = 'Buy upgrades for the club',
                icon = 'signature',
                menu = 'buy_name_upgrades',
            },
            {
                title = 'Change Style',
                description = 'Buy upgrades for the club',
                icon = 'paint-roller',
                menu = 'buy_style_upgrades'
            },
            {
                title = 'Change Podium',
                description = 'Buy upgrades for the club',
                icon = 'chair',
                menu = 'buy_podium_upgrades'
            },
            {
                title = 'Change Speakers',
                description = 'Buy upgrades for the club',
                icon = 'headphones',
                menu = 'buy_speakers_upgrades'
            },
            {
                title = 'Change Security',
                description = 'Buy upgrades for the club',
                icon = 'lock',
                menu = 'buy_security_upgrades'
            },
            {
                title = 'Change Turntables',
                description = 'Buy upgrades for the club',
                icon = 'music',
                menu = 'buy_turntables_upgrade'
            },
            {
                title = 'Change Droplets',
                description = 'Buy upgrades for the club',
                icon = 'lightbulb',
                menu = 'buy_droplets_upgrades'
            },
            {
                title = 'Change Neons',
                description = 'Buy upgrades for the club',
                icon = 'lightbulb',
                menu = 'buy_neons_upgrade'
            },
            {
                title = 'Change Bands',
                description = 'Buy upgrades for the club',
                icon = 'lightbulb',
                menu = 'buy_bands_upgrades'
            },
            {
                title = 'Change Lasers',
                description = 'Buy upgrades for the club',
                icon = 'lightbulb',
                menu = 'buy_lasers_upgrades'
            },
            {
                title = 'Change Booze',
                description = 'Buy upgrades for the club',
                icon = 'beer-mug-empty',
                menu = 'buy_booze_upgrades'
            },
        }
    })

    lib.registerContext({
        id = 'buy_name_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the name',
            },
            {
                title = Config.Price['Upgrades']['Name']['Galaxy'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Galaxy'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Galaxy'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Galaxy')
                end,
            },
            {
                title = Config.Price['Upgrades']['Name']['Studio'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Studio'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Studio'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Studio')
                end,
            },
            {
                title = Config.Price['Upgrades']['Name']['Omega'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Omega'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Omega'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Omega')
                end,
            },
            {
                title = Config.Price['Upgrades']['Name']['Technologie'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Technologie'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Technologie'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Technologie')
                end,
            },
            {
                title = Config.Price['Upgrades']['Name']['Gefangnis'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Gefangnis'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Gefangnis'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Gefangnis')
                end,
            },
            {
                title = Config.Price['Upgrades']['Name']['Misonette'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Misonette'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Misonette'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Misonette')
                end,
            },
            {
                title = Config.Price['Upgrades']['Name']['Tony'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Tony'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Tony'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Tony')
                end,
            },
            {
                title = Config.Price['Upgrades']['Name']['Place'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Place'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Place'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Place')
                end,
            },
            {
                title = Config.Price['Upgrades']['Name']['Paradise'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Name']['Paradise'].price),
                disabled = checkdata(ClubData, 'name', 'Name', 'Paradise'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'name', 'Name', 'Paradise')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_style_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the style',
            },
            {
                title = Config.Price['Upgrades']['Style']['Traditional'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Style']['Traditional'].price),
                disabled = checkdata(ClubData, 'style', 'Style', 'Traditional'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'style', 'Style', 'Traditional')
                end,
            },
            {
                title = Config.Price['Upgrades']['Style']['Edgy'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Style']['Edgy'].price),
                disabled = checkdata(ClubData, 'style', 'Style', 'Edgy'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'style', 'Style', 'Edgy')
                end,
            },
            {
                title = Config.Price['Upgrades']['Style']['Glamerous'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Style']['Glamerous'].price),
                disabled = checkdata(ClubData, 'style', 'Style', 'Glamerous'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'style', 'Style', 'Glamerous')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_podium_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the podium',
            },
            {
                title = Config.Price['Upgrades']['Podium']['Traditional'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Podium']['Traditional'].price),
                disabled = checkdata(ClubData, 'podium', 'Podium', 'Traditional'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'podium', 'Podium', 'Traditional')
                end,
            },
            {
                title = Config.Price['Upgrades']['Podium']['Edgy'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Podium']['Edgy'].price),
                disabled = checkdata(ClubData, 'podium', 'Podium', 'Edgy'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'podium', 'Podium', 'Edgy')
                end,
            },
            {
                title = Config.Price['Upgrades']['Podium']['Glamerous'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Podium']['Glamerous'].price),
                disabled = checkdata(ClubData, 'podium', 'Podium', 'Glamerous'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'podium', 'Podium', 'Glamerous')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_speakers_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the speakers',
            },
            {
                title = Config.Price['Upgrades']['Speakers']['Basic'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Speakers']['Basic'].price),
                disabled = checkdata(ClubData, 'speakers', 'Speakers', 'Basic'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'speakers', 'Speakers', 'Basic')
                end,
            },
            {
                title = Config.Price['Upgrades']['Speakers']['Ultimate'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Speakers']['Ultimate'].price),
                disabled = checkdata(ClubData, 'speakers', 'Speakers', 'Ultimate'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'speakers', 'Speakers', 'Ultimate')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_security_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the security',
            },
            {
                title = Config.Price['Upgrades']['Security']['Basic'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Security']['Basic'].price),
                disabled = checkdata(ClubData, 'security', 'Security', 'Basic'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'security', 'Security', 'Basic')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_turntables_upgrade',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the turntables',
            },
            {
                title = Config.Price['Upgrades']['Turntables']['Basic'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Turntables']['Basic'].price),
                disabled = checkdata(ClubData, 'turntables', 'Turntables', 'Basic'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'turntables', 'Turntables', 'Basic')
                end,
            },
            {
                title = Config.Price['Upgrades']['Turntables']['Upgraded'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Turntables']['Upgraded'].price),
                disabled = checkdata(ClubData, 'turntables', 'Turntables', 'Upgraded'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'turntables', 'Turntables', 'Upgraded')
                end,
            },
            {
                title = Config.Price['Upgrades']['Turntables']['Mega'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Turntables']['Mega'].price),
                disabled = checkdata(ClubData, 'turntables', 'Turntables', 'Mega'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'turntables', 'Turntables', 'Mega')
                end,
            },
            {
                title = Config.Price['Upgrades']['Turntables']['Ultimate'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Turntables']['Ultimate'].price),
                disabled = checkdata(ClubData, 'turntables', 'Turntables', 'Ultimate'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'turntables', 'Turntables', 'Ultimate')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_droplets_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the droplets lights',
            },
            {
                title = Config.Price['Upgrades']['Droplets']['Yellow'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Droplets']['Yellow'].price),
                disabled = checkdata(ClubData, 'droplets', 'Droplets', 'Yellow'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'droplets', 'Droplets', 'Yellow')
                end,
            },
            {
                title = Config.Price['Upgrades']['Droplets']['White'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Droplets']['White'].price),
                disabled = checkdata(ClubData, 'droplets', 'Droplets', 'White'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'droplets', 'Droplets', 'White')
                end,
            },
            {
                title = Config.Price['Upgrades']['Droplets']['Purple'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Droplets']['Purple'].price),
                disabled = checkdata(ClubData, 'droplets', 'Droplets', 'Purple'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'droplets', 'Droplets', 'Purple')
                end,
            },
            {
                title = Config.Price['Upgrades']['Droplets']['Cayn'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Droplets']['Cayn'].price),
                disabled = checkdata(ClubData, 'droplets', 'Droplets', 'Cayn'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'droplets', 'Droplets', 'Cayn')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_neons_upgrade',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the neons lights',
            },
            {
                title = Config.Price['Upgrades']['Neons']['Yellow'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Neons']['Yellow'].price),
                disabled = checkdata(ClubData, 'neons', 'Neons', 'Yellow'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'neons', 'Neons', 'Yellow')
                end,
            },
            {
                title = Config.Price['Upgrades']['Neons']['White'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Neons']['White'].price),
                disabled = checkdata(ClubData, 'neons', 'Neons', 'White'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'neons', 'Neons', 'White')
                end,
            },
            {
                title = Config.Price['Upgrades']['Neons']['Purple'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Neons']['Purple'].price),
                disabled = checkdata(ClubData, 'neons', 'Neons', 'Purple'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'neons', 'Neons', 'Purple')
                end,
            },
            {
                title = Config.Price['Upgrades']['Neons']['Cayn'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Neons']['Cayn'].price),
                disabled = checkdata(ClubData, 'neons', 'Neons', 'Cayn'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'neons', 'Neons', 'Cayn')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_bands_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the bands lights',
            },
            {
                title = Config.Price['Upgrades']['Bands']['Yellow'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Bands']['Yellow'].price),
                disabled = checkdata(ClubData, 'bands', 'Bands', 'Yellow'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'bands', 'Bands', 'Yellow')
                end,
            },
            {
                title = Config.Price['Upgrades']['Bands']['Green'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Bands']['Green'].price),
                disabled = checkdata(ClubData, 'bands', 'Bands', 'Green'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'bands', 'Bands', 'Green')
                end,
            },
            {
                title = Config.Price['Upgrades']['Bands']['White'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Bands']['White'].price),
                disabled = checkdata(ClubData, 'bands', 'Bands', 'White'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'bands', 'Bands', 'White')
                end,
            },
            {
                title = Config.Price['Upgrades']['Bands']['Cayn'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Bands']['Cayn'].price),
                disabled = checkdata(ClubData, 'bands', 'Bands', 'Cayn'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'bands', 'Bands', 'Cayn')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_lasers_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the lasers lights',
            },
            {
                title = Config.Price['Upgrades']['Lasers']['Yellow'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Lasers']['Yellow'].price),
                disabled = checkdata(ClubData, 'lasers', 'Lasers', 'Yellow'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'lasers', 'Lasers', 'Yellow')
                end,
            },
            {
                title = Config.Price['Upgrades']['Lasers']['Green'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Lasers']['Green'].price),
                disabled = checkdata(ClubData, 'lasers', 'Lasers', 'Green'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'lasers', 'Lasers', 'Green')
                end,
            },
            {
                title = Config.Price['Upgrades']['Lasers']['White'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Lasers']['White'].price),
                disabled = checkdata(ClubData, 'lasers', 'Lasers', 'White'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'lasers', 'Lasers', 'White')
                end,
            },
            {
                title = Config.Price['Upgrades']['Lasers']['Purple'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Lasers']['Purple'].price),
                disabled = checkdata(ClubData, 'lasers', 'Lasers', 'Purple'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'lasers', 'Lasers', 'Purple')
                end,
            },
        }
    })

    lib.registerContext({
        id = 'buy_booze_upgrades',
        title = 'Buy Upgrades',
        options = {
            {
                title = 'Edit the booze',
            },
            {
                title = Config.Price['Upgrades']['Booze']['1'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Booze']['1'].price),
                disabled = checkdata(ClubData, 'booze', 'Booze', '1'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'booze', 'Booze', '1')
                end,
            },
            {
                title = Config.Price['Upgrades']['Booze']['2'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Booze']['2'].price),
                disabled = checkdata(ClubData, 'booze', 'Booze', '2'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'booze', 'Booze', '2')
                end,
            },
            {
                title = Config.Price['Upgrades']['Booze']['3'].description,
                description = 'The price is ' .. tostring(Config.Price['Upgrades']['Booze']['3'].price),
                disabled = checkdata(ClubData, 'booze', 'Booze', '3'),
                icon = 'coins',
                onSelect = function()
                    buyObject(ClubData, 'booze', 'Booze', '3')
                end,
            },
        }
    })

    -- Reputation
    lib.registerContext({
        id = 'reputation_menu',
        title = 'Gain Reputation',
        options = {
            {
                title = 'Boost popularity within the club',
            },
            {
                title = 'Put up posters',
                description = 'Put posters around San Andreas to attract attention',
                icon = 'clipboard-user',
                onSelect = function()
                    TriggerServerEvent('nightclubs:server:posterGetMissionData')
                end,
            },
            {
                title = 'Steal Equiptment',
                description = 'Steal lights, speakers, and turntables from around San Andreas',
                icon = 'radio',
                onSelect = function()
                    TriggerServerEvent('nightclubs:server:equiptmentGetMissionData')
                end,
            },
            {
                title = 'Collect Food',
                description = 'Collect food for customers to buy, affects popularity',
                icon = 'utensils',
                onSelect = function()
                    TriggerServerEvent('nightclubs:server:foodGetData')
                end,
            },
        }
    })

    -- Employee
    lib.registerContext({
        id = 'employee_menu',
        title = 'Hire Employees for your club',
        options = {
            {
                title = 'Hire or Fire Employees',
            },
            {
                title = 'Dj',
                description = 'Hire a dj to play music, requires speakers and turntable',
                icon = 'music',
                menu = 'emoloyee_dj_menu',
                metadata = {
                    { label = 'Payment', value = Config.Employee.dj.price },
                },
            },
            {
                title = 'Dancers',
                description = 'Hire dancers to boost popularity',
                menu = 'emoloyee_dancer_menu',
                icon = 'person-dress',
                metadata = {
                    { label = 'Payment', value = Config.Employee.dancers.price },
                },
            },
            {
                title = 'Bar Tenders',
                description = 'Hire bar tenders and unlock the ability to sell food and drinks',
                icon = 'martini-glass-empty',
                menu = 'emoloyee_tender_menu',
                metadata = {
                    { label = 'Payment', value = Config.Employee.tenders.price },
                },
            },
        }
    })

    lib.registerContext({
        id = 'emoloyee_dj_menu',
        title = 'Hire the DJ',
        options = {
            {
                title = 'Click to hire or fire ' .. Employee['dj'] .. '/' .. #Config.Employee.dj.locations,
            },
            {
                title = 'Hire',
                description = 'Hire a dj to play music, requires speakers and turntable',
                icon = 'check',
                onSelect = function()
                    if ClubData.Metadata['speakers'] ~= tostring(nil) and ClubData.Metadata['turntables'] ~= tostring(nil) then
                        TriggerServerEvent('nightclubs:server:employeesFunction', 'dj', true)
                        QBCore.Functions.Notify('Hired dj sucessfully', "success")
                    else
                        QBCore.Functions.Notify('Could not hire, missing turntables or speakers', "error")
                    end
                    
                end,
                disabled = checkDisabled(Employee, 'dj', Config.Employee.dj.locations, false)
            },
            {
                title = 'Fire',
                description = 'Fire the DJ',
                icon = 'circle-xmark',
                onSelect = function()
                    TriggerServerEvent('nightclubs:server:employeesFunction', 'dj', false)
                    QBCore.Functions.Notify('Fired dj sucessfully', "success")
                end,
                disabled = checkDisabled(Employee, 'dj', Config.Employee.dj.locations, true)
            },
        }
    })

    lib.registerContext({
        id = 'emoloyee_dancer_menu',
        title = 'Hire the Dancers',
        options = {
            {
                title = 'Click to hire or fire '  .. Employee['dancers'] .. '/' .. #Config.Employee.dancers.locations,
            },
            {
                title = 'Hire',
                description = 'Hire the dancers, requires podiums',
                icon = 'check',
                onSelect = function()
                    if ClubData.Metadata['podium'] ~= tostring(nil) then
                        TriggerServerEvent('nightclubs:server:employeesFunction', 'dancers', true)
                        QBCore.Functions.Notify('Hired a dancer sucessfully', "success")
                    else
                        QBCore.Functions.Notify('Could not hire, missing podiums', "error")
                    end
                    
                end,
                disabled = checkDisabled(Employee, 'dancers', Config.Employee.dancers.locations, false)
            },
            {
                title = 'Fire',
                description = 'Fire a dancer',
                icon = 'circle-xmark',
                onSelect = function()
                    TriggerServerEvent('nightclubs:server:employeesFunction', 'dancers', false)
                    QBCore.Functions.Notify('Fired dancer sucessfully', "success")
                end,
                disabled = checkDisabled(Employee, 'dancers', Config.Employee.dancers.locations, true)
            },
        }
    })

    lib.registerContext({
        id = 'emoloyee_tender_menu',
        title = 'Hire the Bar Tenders',
        options = {
            {
                title = 'Click to hire or fire '  .. Employee['tenders'] .. '/' .. #Config.Employee.tenders.locations,
            },
            {
                title = 'Hire',
                description = 'Hire the bar tenders',
                icon = 'check',
                onSelect = function()
                        TriggerServerEvent('nightclubs:server:employeesFunction', 'tenders', true)
                        QBCore.Functions.Notify('Hired a bar tender sucessfully', "success")         
                end,
                disabled = checkDisabled(Employee, 'tenders', Config.Employee.tenders.locations, false)
            },
            {
                title = 'Fire',
                description = 'Fire a bar tender',
                icon = 'circle-xmark',
                onSelect = function()
                    TriggerServerEvent('nightclubs:server:employeesFunction', 'tenders', false)
                    QBCore.Functions.Notify('Fired bar tender sucessfully', "success")
                end,
                disabled = checkDisabled(Employee, 'tenders', Config.Employee.tenders.locations, true)
            },
        }
    })
end)