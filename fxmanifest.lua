fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Epixx1337'
description 'Battering ram melee weapon for Qbox and ox_inventory'
version '1.0.0'

files {
    'data/weapons.meta',
    'data/weaponanimations.meta',
    'data/weaponarchetypes.meta',
    'data/pedpersonality.meta',
}

data_file 'WEAPONINFO_FILE' 'data/weapons.meta'
data_file 'WEAPON_ANIMATIONS_FILE' 'data/weaponanimations.meta'
data_file 'WEAPON_METADATA_FILE' 'data/weaponarchetypes.meta'
data_file 'PED_PERSONALITY_FILE' 'data/pedpersonality.meta'

client_script 'cl_weaponNames.lua'
