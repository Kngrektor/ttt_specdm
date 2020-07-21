SpecDM.OverrideOld = SpecDM.OverrideOld or {}

local old_fns = SpecDM.OverrideOld
local new_fns = {}

local function override_fun(name, old, new)
	old_fns[name] = old_fns[name] or old
	new_fns[name] = new

	return function(...)
		local result = new_fns[name] and {new_fns[name](old_fns[name], ...)}
		if result[1] then
			return old_fns[name](...)
		else
			return select(2, unpack(result))
		end
	end
end

function SpecDM.OverrideFunc(tbl, fun, new)
	print("Adding override func", tbl, fun, new)
	tbl[fun] = override_fun("func:"..fun, tbl[fun], new)
end
function SpecDM.OverrideEnt(class, fun, new)
	print("Adding override ent", class, fun, new)
	local tbl = scripted_ents.Get(class)
	tbl[fun] = override_fun(class..":"..fun, tbl[fun], new)
end


local overrides = {}


local function overrides_call(group, cb)
	cb(SpecDM.OverrideFunc, SpecDM.OverrideEnt)
end

function SpecDM.OverridesAdd(group, cb)
	if SpecDM.overrides_post_init then
		overrides_call(group, cb)
	else
		overrides[group] = cb
	end
end

hook.Add("Initialize", "SpecDM Overrides", function()
	SpecDM.overrides_post_init = true
	for group, cb in pairs(overrides) do
		overrides_call(group,cb)
	end
end)
if SpecDM.overrides_post_init then
	for group, cb in pairs(overrides) do
		overrides_call(group,cb)
	end
end