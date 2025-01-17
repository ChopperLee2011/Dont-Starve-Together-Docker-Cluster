local assets =
{
  Asset("ANIM", "anim/sandhill.zip")
}

local function ongustblowawayfn(inst)
  if not inst.components.inventoryitem or not inst.components.inventoryitem.owner then 
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("inspectable")
    inst.SoundEmitter:PlaySound("dontstarve/common/dust_blowaway")
    inst.AnimState:PlayAnimation("disappear")
    inst:ListenForEvent("animover", function() inst:Remove() end)
  end 
end

local function sandfn()
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBuild( "sandhill" )
  inst.AnimState:SetBank( "sandhill" )
  inst.AnimState:PlayAnimation("idle")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("inspectable")
  -----------------
  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
  ----------------------

  MakeInvItemIA(inst)
	inst.components.inventoryitem:SetSinks(true)

	inst:AddComponent("blowinwindgust")
	inst.components.blowinwindgust:SetWindSpeedThreshold(TUNING.SAND_WINDBLOWN_SPEED)
	inst.components.blowinwindgust:SetDestroyChance(TUNING.SAND_WINDBLOWN_FALL_CHANCE)
	inst.components.blowinwindgust:SetDestroyFn(ongustblowawayfn)

  return inst
end

return Prefab( "sand", sandfn, assets)
