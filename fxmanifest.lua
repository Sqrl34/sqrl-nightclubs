fx_version 'cerulean'
game 'gta5'

description 'sqrl-nightclubs'
version '1.1'
author 'Sqrl'

shared_scripts {
    'config.lua',
    '@oxmysql/lib/MySQL.lua',
    '@ox_lib/init.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
    'client/menus.lua',
    'client/missions/posters.lua',
    'client/missions/turntables.lua',
    'client/missions/food.lua',
    'client/visiting.lua',
}

server_script {
    'server/main.lua',
    'server/missions/posters.lua',
    'server/missions/turntables.lua',
    'server/missions/food.lua',
    'server/visiting.lua',
}

lua54 'yes'
