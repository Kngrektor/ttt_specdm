if SERVER then
	SpecDM.OverridesAdd("player", function(func)
		-- Has to be overriden, gamemode calls it directly
		func(GAMEMODE, "PlayerSpawnAsSpectator", function(old, gm, ply)
			if not ply:IsGhost() then return true end
			-- If we're a ghost we're already a spec and spawned
		end)

		func(GAMEMODE, "PlayerSpawn", function(old, gm, ply)
			if not ply:IsGhost() then return true end

			PROPSPEC.Clear(ply)

			util.StopBleeding(ply)
			ply:ResetViewRoll()
			ply:UnSpectate()
			hook.Call("PlayerSetModel", GAMEMODE, ply)
			hook.Call("TTTPlayerSetColor", GAMEMODE, ply)
			ply:SetupHands()

			ply:SetNoTarget(true)
			SpecDM.GiveLoadout(ply)
		end)

		func(GAMEMODE, "PlayerDeath", function(old, gm, vic, infl, att)
			if not vic:IsGhost() then return true end

			util.StopBleeding(vic)
			vic:Flashlight(false)
			vic:Extinguish()
		end)

		func(GAMEMODE, "SpectatorThink", function(old, gm, ply)
			if not ply:IsGhost() then return true end
		end)

		func(GAMEMODE, "KeyPress", function(old, gm, ply, key)
			if not ply:IsGhost() then return true end
		end)
	end)

	-- https://github.com/Facepunch/garrysmod/blob/master/garrysmod/gamemodes/base/gamemode/player.lua#L109
	hook.Add("PlayerDeathThink", "SpecDM", function(ply)
		if not ply:IsGhost() then return end

		if ply.NextSpawnTime and ply.NextSpawnTime > CurTime() then return end
		if ply:IsBot() or ply:KeyPressed(IN_ATTACK) or ply:KeyPressed(IN_ATTACK2) or ply:KeyPressed(IN_JUMP) then
			ply:Spawn()
		end
	end)

	hook.Add("PostPlayerDeath", "SpecDM", function(ply)
		if not ply:IsGhost() then return end
		ply.NextSpawnTime = CurTime() + SpecDM.RespawnTime
	end)
end