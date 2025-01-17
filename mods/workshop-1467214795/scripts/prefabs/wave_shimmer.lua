local assets =
{
	Asset( "ANIM", "anim/wave_shimmer.zip" ),
	Asset( "ANIM", "anim/wave_shimmer_med.zip" ),
	Asset( "ANIM", "anim/wave_shimmer_deep.zip" ),
	Asset( "ANIM", "anim/wave_shimmer_river.zip" ),
	Asset( "ANIM", "anim/wave_shimmer_flood.zip" ),
	Asset( "ANIM", "anim/wave_hurricane.zip" )
}

local function onSleep(inst)
	inst:Remove()
end

local function animover(inst)
	inst:Remove()
end

local function commonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("wave_hurricane")
	inst.AnimState:SetBuild("wave_hurricane")
	-- inst.AnimState:PlayAnimation( "idle", false )
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(ANIM_SORT_ORDER.OCEAN_WAVES)

	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.persists = false

	inst.OnEntitySleep = onSleep
	inst:ListenForEvent( "animover", animover )
	
    return inst
end

local function shallowfn()
	local inst = commonfn()
	if TheWorld.state.iswinter then
		-- local ocean = GetWorld().components.ocean
		-- inst.Transform:SetRotation(-ocean:GetCurrentAngle())
		inst.Transform:SetTwoFaced()
	    inst.AnimState:SetBuild( "wave_hurricane" )
	    inst.AnimState:SetBank( "wave_hurricane" )
	    inst.AnimState:PlayAnimation( "idle_small", false )
	else
	    inst.AnimState:SetBuild( "wave_shimmer" )
	    inst.AnimState:SetBank( "shimmer" )
	    inst.AnimState:PlayAnimation( "idle", false )
	end
	return inst
end

local function medfn()
	local inst = commonfn()
	if TheWorld.state.iswinter then
		-- local ocean = GetWorld().components.ocean
		-- inst.Transform:SetRotation(-ocean:GetCurrentAngle())
		inst.Transform:SetTwoFaced()
	    inst.AnimState:SetBuild( "wave_hurricane" )
	    inst.AnimState:SetBank( "wave_hurricane" )
	    inst.AnimState:PlayAnimation( "idle_med", false )
	else
	    inst.AnimState:SetBuild( "wave_shimmer_med" )
	    inst.AnimState:SetBank( "shimmer" )
	    inst.AnimState:PlayAnimation( "idle", false )
	end
	return inst
end

local function deepfn()
	local inst = commonfn()
	if TheWorld.state.iswinter then
		-- local ocean = GetWorld().components.ocean
		-- inst.Transform:SetRotation(-ocean:GetCurrentAngle())
		inst.Transform:SetTwoFaced()
	    inst.AnimState:SetBuild( "wave_hurricane" )
	    inst.AnimState:SetBank( "wave_hurricane" )
	    inst.AnimState:PlayAnimation( "idle_deep", false )
	else
	    inst.AnimState:SetBuild( "wave_shimmer_deep" )
	    inst.AnimState:SetBank( "shimmer_deep" )
	    inst.AnimState:PlayAnimation( "idle", false )
	end
	return inst
end

local function floodfn(Sim)
	local inst = commonfn()
    inst.AnimState:SetBuild( "wave_shimmer_flood" )
    inst.AnimState:SetBank( "wave_shimmer_flood" )
    inst.AnimState:PlayAnimation( "idle", false )
	return inst
end

local function riverfn(Sim)
	local inst = commonfn()
    inst.AnimState:SetBuild( "wave_shimmer_river" )
    inst.AnimState:SetBank( "shimmer" )
    inst.AnimState:PlayAnimation( "a".. math.random(2), false )
	return inst
end

return Prefab( "wave_shimmer", shallowfn, assets ),
		Prefab( "wave_shimmer_med", medfn, assets ),
		Prefab( "wave_shimmer_deep", deepfn, assets ),
		Prefab( "wave_shimmer_river", riverfn, assets ),
		Prefab( "wave_shimmer_flood", floodfn, assets )
