fx_version 'cerulean'
game 'gta5'

author 'Off-Grid Roleplay - Pet Scripts'
description 'Discord Role-Based Vehicle Pack Menu System'
version '2.0.0'

-- Files that users can edit (NOT escrowed)
files {
    'logo.png'
}

-- Client scripts (will be escrowed)
client_scripts {
    'config.lua',  -- Keep config accessible for users to edit
    'client/client.lua'
}

-- Server scripts (will be escrowed)
server_scripts {
    'config.lua',  -- Keep config accessible for users to edit
    'server/server.lua'
}

-- Escrow configuration
-- These files will be encrypted by CFX escrow tool
escrow_ignore {
    'config.lua',           -- Users need to edit this
    'README.md',            -- Documentation
    'DISCORD_SETUP.txt',    -- Setup instructions
    'INSTALLATION.txt'      -- Installation guide
}

dependency 'badger_discord_api'
