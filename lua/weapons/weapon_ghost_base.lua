AddCSLuaFile()

--[[
	FireBullets override
]]
local function collides_with(ent)
	if ent:IsWorld() then return true end
	if ent.IsGhost and ent:IsGhost() then return true end
end

hook.Add("EntityFireBullets", "SpecDM", function(ply, bullet)
	if not ply:IsGhost() then return end

	local cb = bullet.Callback or function() end
	function bullet.Callback(att, tr, dmg)
		if not tr.Entity or collides_with(tr.Entity) then
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
	if att.IsGhost and att:IsGhost() and not collides_with(ent) then
		return true
	end
end)


--[[
	Actual Swep
]]
SWEP.Base = "weapon_tttbase"
SWEP.AllowDrop = false

function SWEP:IsGhost()
	return true
end

-- Disable random clientside effects
if SERVER then return end

-- Not using DEFINE_BASECLASS as that makes luacheck sad :(
local BASE = baseclass.Get(SWEP.Base)

function SWEP:DoImpactEffect(...)
	if not LocalPlayer():IsGhost() then return true end
	BASE.DoImpactEffect(self, ...)
end

function SWEP:FireAnimationEvent(...)
	if not LocalPlayer():IsGhost() then return true end
	BASE.FireAnimationEvent(self, ...)
end

function SWEP:DrawWorldModel(...)
	if not LocalPlayer():IsGhost() then return end
	BASE.DrawWorldModel(self, ...)
end
function SWEP:DrawWorldModelTranslucent(...)
	if not LocalPlayer():IsGhost() then return end
	BASE.DrawWorldModelTranslucent(self, ...)
end

-- Seems like this is never used by TTT but might as well disable it
function SWEP:ShootEffects(...)
	if not LocalPlayer():IsGhost() then return end
	BASE.ShootEffects(self, ...)
end
