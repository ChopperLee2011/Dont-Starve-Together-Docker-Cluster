local assets =
{
  Asset("ANIM", "anim/poison_antidote.zip"),
}

local function fn()
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeInventoryPhysics(inst)

  inst.AnimState:SetBank("poison_antidote")
  inst.AnimState:SetBuild("poison_antidote")
  inst.AnimState:PlayAnimation("idle")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle")
	
  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end
  
  inst:AddComponent("stackable")
  inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

  inst:AddComponent("inspectable")

  MakeInvItemIA(inst, "antivenom")

  inst:AddComponent("poisonhealer")

  MakeHauntableLaunch(inst)

  return inst
end

return Prefab( "antivenom", fn, assets) 

