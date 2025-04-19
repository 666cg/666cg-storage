fx_version 'cerulean'
game 'gta5'

author '666cg'
description 'Kişisel ve Meslek Depo'
version '1.0.0'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/depo_ui.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/depo_ui.html',
    'html/depo_ui.css',
    'html/depo_ui.js'
}

dependencies {
    'ox_inventory',
    'qb-core'
}

escrow_ignore {
    'config.lua',
    'client/*.lua',
    'server/*.lua',
    'html/*.html',
    'html/*.css',
    'html/*.js',
    'README.md',
    'LICENSE'
}

lua54 'yes' 