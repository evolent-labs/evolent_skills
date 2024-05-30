fx_version 'cerulean'

game 'gta5'

author "Evolent"
version '1.0.0'

lua54 'yes'

shared_script '@ox_lib/init.lua'

client_script "client/main.lua"
server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/main.lua',
  'server/commands.lua'
}

ui_page 'web/build/index.html'

files {
  'config.lua',
  'web/build/index.html',
  'web/build/**/*'
}

lua54 'yes'
use_fxv2_oal 'yes'
