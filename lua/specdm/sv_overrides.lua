SpecDM.OverridesAdd("sv_overrides", function(func, ent)
	func(PROPSPEC, "Start", function(old, ply, _ent)
		if not ply:IsGhost() then return true end
	end)

	local PLAYER = FindMetaTable("Player")
	func(PLAYER, "Spectate", function(old, ...)
		print("Woah! Called spectate ", ...)
		debug.Trace()
		return true
	end)

	ent("ttt_logic_role", "AcceptInput", function(old, self, name, activator, caller, data)
		if not IsValid(activator) then return true end
		if not activator.IsGhost then return true end
		if not activator:IsGhost() then return true end
	end)
end)

hook.Add("EntityEmitSound", "SpecDM", function(sound)
	local ent = sound.Entity
	if not ent or not IsValid(ent) then return end
	if ent.IsGhost and ent:IsGhost() then return false end
end)

hook.Add("TTTBeginRound", "SpecDM", function()
	for _, v in ipairs(player.GetAll()) do
		if v:IsTerror() then
			v:SetNWBool("PlayedSRound", true)
		else
			v:SetNWBool("PlayedSRound", false)
		end
	end
end)

--[[local old_KarmaHurt = KARMA.Hurt
function KARMA.Hurt(attacker, victim, dmginfo)
	if (IsValid(attacker) and attacker:IsGhost()) or (IsValid(victim) and victim:IsGhost()) then return end

	return old_KarmaHurt(attacker, victim, dmginfo)
end]]

--[[
	local old_Damagelog = DamageLog
	function Damagelog_New(str)
		return old_Damagelog(str)
	end

	function DamageLog(str)
		if string.Left(str, 4) ~= "KILL" and string.Left(str, 3) ~= "DMG" then
			Damagelog_New(str)
		end
	end
]]