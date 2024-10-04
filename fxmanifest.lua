fx_version 'cerulean'
game 'gta5'

lua54 'yes'

author 'Bando'
description 'QB-Core Elevator Script'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

dependencies {
    'qb-core'
}

-- Optional dependencies
optionals {
    --'qb-menu',
    'bs-menu',
    --'qb-notify',
    'bs-notify',
    'qb-target'
}

escrow_ignore {
    'server/server.lua',
    'client/client.lua',
    'config.lua',
    'fxmanifest.lua',
    'README.md',
    'LICENSE'
}

