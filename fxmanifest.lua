fx_version 'cerulean'
game 'gta5'

author 'Treety'
description 'Advanced Dice Script'
version '2.0.0'

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'locales/*.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}