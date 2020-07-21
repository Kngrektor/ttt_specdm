SpecDM = SpecDM or {}

local CL = SERVER and AddCSLuaFile or include
local SV = SERVER and include or function() end
local function SH(file) CL(file) SV(file) end

SH("libs/von.lua")
SH("specdm/config.lua")

SH("specdm/sh_overrides.lua")

CL("specdm/cl_specdm.lua")
SV("specdm/sv_specdm.lua")
SH("specdm/sh_specdm.lua")

SH("specdm/sh_player.lua")
SH("specdm/sh_weapons.lua")

CL("specdm/cl_hud.lua")
CL("vgui/spec_dm_loadout.lua")
CL("specdm/cl_stats.lua")

SV("specdm/sv_overrides.lua")
SV("specdm/sv_stats.lua")

SH("specdm/sh_announcer.lua")