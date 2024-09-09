fx_version 'cerulean'

game 'gta5'

author 'sams(Blank not found)'

description 'sams-Aircraft heist'

version '0.1'

client_scripts{
    'client.lua',
    '@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'@PolyZone/EntityZone.lua',
	'@PolyZone/CircleZone.lua',
	'@PolyZone/ComboZone.lua'
}

shared_scripts{
    '@ox_lib/init.lua',
    'config.lua',
}

server_scripts{
    'server.lua',
}