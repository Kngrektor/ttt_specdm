--[[
	Weapon list
]]
SpecDM.Primarys   = SpecDM.Primarys   or {}
SpecDM.Secondarys = SpecDM.Secondarys or {}

function SpecDM.AddWeapon(wep)
	if wep.Kind ~= WEAPON_HEAVY and wep.Kind ~= WEAPON_PISTOL then return end

	local tbl = SpecDM[(wep.Kind == WEAPON_HEAVY and "Primary" or "Secondary").."s"]

	if not table.HasValue(tbl, wep.ClassName) then
		table.insert(tbl, wep.ClassName)
	end
end

-- Add existing weapons
hook.Add("Intialize", "SpecDM Weapons", function()
	for _, wep in pairs(weapons.GetList()) do
		if wep.AutoSpawnable and not WEPS.IsEquipment(wep) then
			SpecDM.AddWeapon(wep)
		end
	end
end)
for _, wep in pairs(weapons.GetList()) do
	if wep.AutoSpawnable and not WEPS.IsEquipment(wep) then
		SpecDM.AddWeapon(wep)
	end
end

--[[
	Loadouts
]]
if SERVER then
	function SpecDM.GiveLoadout(ply)
		ply:Give("weapon_zm_improvised")

		if #SpecDM.Primarys > 0 then
			local wep = SpecDM.Primarys[math.random(#SpecDM.Primarys)]
			print(wep)
			ply:Give(wep)
		end

		if #SpecDM.Secondarys > 0 then
			local wep = SpecDM.Secondarys[math.random(#SpecDM.Secondarys)]
			print(wep)
			ply:Give(wep)
		end
	end
end


--[[
	Overrides
]]
if SERVER then
	SpecDM.OverridesAdd("sh_weapons", function(func, ent)
		local PLAYER = FindMetaTable("Player")

		local is_giving
		func(GAMEMODE, "PlayerCanPickupWeapon", function(old, gm, ply, wep)
			if not ply:IsGhost() then return true end
			return false, is_giving
		end)
		func(PLAYER, "Give", function(old, ply, wep)
			if not ply:IsGhost() then return true end

			is_giving = true
			wep = old(ply, wep)
			is_giving = false

			return false, wep
		end)
	end)
end

-- TODO: Put these in sh_specdm.lua
local function is_ghost(ent)
	return ent.IsGhost and ent:IsGhost()
end

local function is_ghastly(ent)
	if ent:IsWorld() then return true end
	if is_ghost(ent) then return true end
end

local function collide(a,b)
	return (not is_ghost(a) or is_ghastly(b))
	    or (not is_ghost(b) or is_ghastly(a))
end

--[[
	Bullets and damage
]]
hook.Add("EntityFireBullets", "SpecDM", function(ent, bullet)
	local cb = bullet.Callback or function() end
	function bullet.Callback(att, tr, dmg)
		local tr_ent = tr.Entity
		if not IsValid(att) or not IsValid(tr_ent) or collide(att, tr_ent) then
			return cb(att, tr, dmg)
		end

		-- Modify the bullet
		-- advance 1 unit to avoid infinite loops
		bullet.Src      = tr.HitPos + tr.Normal
		bullet.Distance = bullet.Distance * (1-tr.Fraction) - 1

		-- Fire the new bullet
		att:FireBullets(bullet)
	end

	return true
end)

hook.Add("EntityTakeDamage", "SpecDM", function(ent, dmg)
	local att = dmg:GetAttacker()
	if not IsValid(att) or not collide(att, ent) then
		return true
	end
end)