Schema.name = "Black Mesa"
Schema.author = "LimeFruit"
Schema.description = "Working on a better tomorrow for mankind."
Schema.version = "Legacy"
Schema.logo = "materials/limefruit/server-logo_new_inverted.png"
Schema.color = Color(0, 211, 105, 255)

-- Schema configs
ix.config.Set("walkSpeed", 90)
ix.config.SetDefault("walkSpeed", 90)
ix.config.Set("color", Schema.color)

-- Include additional files
ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")

ix.util.Include("meta/sh_character.lua")
ix.util.Include("meta/sh_player.lua")

ix.util.Include("libs/thirdparty/sh_netstream2.lua")
ix.util.Include("libs/sh_command.lua")

-- Animations
ix.anim.SetModelClass("models/humans/marine.mdl", "overwatch")
ix.anim.SetModelClass("models/limefruitbmce/marine.mdl", "overwatch")
ix.anim.SetModelClass("models/limefruitbmce/marine_02.mdl", "overwatch")
ix.anim.SetModelClass("models/blackfloggerhev-male/male_hevsuit.mdl", "player")
ix.anim.SetModelClass("models/fearless/chef1.mdl", "player")
ix.anim.SetModelClass("models/humans/pyri_pm/cafeteria_female_pm.mdl", "citizen_female")
ix.anim.SetModelClass("models/bloocobalt/splinter cell/chemsuit.mdl", "player")
ix.anim.SetModelClass("models/blackfloggerhev-male/male_hevsuit.mdl", "citizen_male")
ix.anim.SetModelClass("models/player/female_02_suit.mdl", "citizen_female")
ix.anim.SetModelClass("models/humans/hev_mark3.mdl", "player")
ix.anim.SetModelClass("models/maolong/heavy/bms_security_guard_01.mdl", "player")
ix.anim.SetModelClass("models/limefruit/hev/male.mdl", "citizen_male")
