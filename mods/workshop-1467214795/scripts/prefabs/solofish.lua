local assets =
{
  Asset("ANIM", "anim/fish_dogfish.zip"),
}

local prefabs =
{
  "solofish_dead"
}

local brain = require "brains/solofishbrain"

local function SetLocoState(inst, state)
  --"above" or "below"
  inst.LocoState = string.lower(state)
end

local function IsLocoState(inst, state)
  return inst.LocoState == string.lower(state)
end

local function solofishfn()

  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  MakeCharacterPhysics(inst, 1, 0.5)
  inst.Physics:ClearCollisionMask()
  inst.Physics:CollidesWith(COLLISION.WORLD)
  inst.entity:AddSoundEmitter()

  inst:AddTag("aquatic")

  inst.AnimState:SetBank("dogfish")
  inst.AnimState:SetBuild("fish_dogfish")
  inst.AnimState:PlayAnimation("shadow", true)
  inst.AnimState:SetRayTestOnBB(true)
  inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )

  inst.AnimState:SetLayer( LAYER_BACKGROUND )
  inst.AnimState:SetSortOrder( 3 )

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("locomotor")
  inst.components.locomotor.walkspeed = TUNING.SOLOFISH_WALK_SPEED
  inst.components.locomotor.runspeed = TUNING.SOLOFISH_RUN_SPEED

  inst:AddComponent("inspectable")
  inst.no_wet_prefix = true

  inst:AddComponent("knownlocations")

  inst:AddComponent("combat")
  --inst.components.combat.hiteffectsymbol = "chest"
  inst:AddComponent("health")
  inst.components.health:SetMaxHealth(TUNING.SOLOFISH_HEALTH)

  inst:AddComponent("eater")
  inst:AddComponent("lootdropper")
  inst.components.lootdropper:SetLoot({"solofish_dead"})

  inst:AddComponent("sleeper")
  inst.components.sleeper.onlysleepsfromitems = true 
  MakeMediumFreezableCharacter(inst, "dogfish_body")

  SetLocoState(inst, "below")
  inst.SetLocoState = SetLocoState
  inst.IsLocoState = IsLocoState

  inst:SetStateGraph("SGsolofish")

  inst:SetBrain(brain)

  return inst
end

return Prefab( "solofish", solofishfn, assets, prefabs)
