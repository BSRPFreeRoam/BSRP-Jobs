fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'bsrp-jobs'
author 'BS Race'
description 'BSRP civilian & service job scripts — routes, workplaces, garages (no qb-core)'
version '1.0.0'

ui_page 'html/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config/jobs.lua',
    'shared/fw.lua',
}

client_scripts {
    'client/main.lua',
    'client/workplace.lua',
    'client/routes.lua',
    'client/mechanic.lua',
    'client/tow.lua',
    'client/hunter.lua',
    'client/food.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'bsrp',
}

-- police / ambulance have dedicated resources (bsrp-policejob, bsrp-ambulancejob)
