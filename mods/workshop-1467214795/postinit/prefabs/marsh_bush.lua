local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local _makeemptyfn
local function makeemptyfn(inst, ...)
	inst.components.hackable.canbehacked = false
	if _makeemptyfn then _makeemptyfn(inst, ...) end
end
local function makeemptyfn_hackable(inst)
	inst.components.pickable:MakeEmpty() -- This does everything for us
end

local _makebarrenfn
local function makebarrenfn(inst, ...)
	inst.components.hackable.canbehacked = false
	if _makebarrenfn then _makebarrenfn(inst, ...) end
end
local function makebarrenfn_hackable(inst)
	inst.components.pickable:MakeBarren() -- This does everything for us
end

local _onpickedfn
local function onpickedfn(inst, ...)
	inst.components.hackable.canbehacked = false
	if _onpickedfn then _onpickedfn(inst, ...) end
end

local function onfinishfn_hackable(inst, doer, loot)
	doer.SoundEmitter:PlaySound("dontstarve/wilson/harvest_sticks")
	inst.components.pickable:Pick(inst) -- Purposefully no valid doer given to avoid damage & double loot
end

local _onregenfn
local function onregenfn(inst, ...)
	inst.components.hackable:Regen()
	if _onregenfn then _onregenfn(inst, ...) end
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddPrefabPostInit("marsh_bush", function(inst)


if TheWorld.ismastersim then

	inst:AddComponent("hackable")
	inst.components.hackable:SetUp("twigs")
	inst.components.hackable.max_cycles = 127 -- dirty, but realistically speaking, never reached anyways
	inst.components.hackable.cycles_left = 127
	inst.components.hackable.hacksleft = 1
	inst.components.hackable.maxhacks = 1
	
	_makeemptyfn = inst.components.pickable.makeemptyfn
	inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.hackable.makeemptyfn = makeemptyfn_hackable
	
	_makebarrenfn = inst.components.pickable.makebarrenfn
	inst.components.pickable.makebarrenfn = makebarrenfn
	inst.components.hackable.makebarrenfn = makebarrenfn_hackable
	
	_onpickedfn = inst.components.pickable.onpickedfn
	inst.components.pickable.onpickedfn = onpickedfn
	
	inst.components.hackable.onfinishfn = onfinishfn_hackable
	
	_onregenfn = inst.components.pickable.onregenfn
	inst.components.pickable.onregenfn = onregenfn
	
end


end)
