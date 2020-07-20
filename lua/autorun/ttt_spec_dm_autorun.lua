SpecDM = SpecDM or {}

local CL = SERVER and AddCSLuaFile or include
local SV = SERVER and include or function() end
local function SH(file) CL(file) SV(file) end

SH("specdm_config.lua")
SH("specdm_von.lua")

CL("cl_spectator_deathmatch.lua")
SV("sv_spectator_deathmatch.lua")
SH("sh_spectator_deathmatch.lua")

CL("cl_specdm_hud.lua")
CL("vgui/spec_dm_loadout.lua")
CL("cl_stats.lua")

SV("sv_specdm_overrides.lua")
SV("sv_stats.lua")

CL("cl_quakesounds.lua")
SV("sv_quakesounds.lua")