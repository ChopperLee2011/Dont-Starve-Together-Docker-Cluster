local assets =
{
  Asset("ANIM", "anim/merm_fisherman_house.zip"),
}

local prefabs =
{
  "mermfisher",
  "collapse_big",
}

local loot =
{
  "boards",
  "rocks",
  "fish_tropical",
}

local function onhammered(inst, worker)
  if inst:HasTag("fire") and inst.components.burnable then
    inst.components.burnable:Extinguish()
  end
  inst:RemoveComponent("childspawner")
  inst.components.lootdropper:DropLoot()
	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
  inst:Remove()
end

local function onhit(inst, worker)
  if not inst:HasTag("burnt") then
    if inst.components.childspawner then
      inst.components.childspawner:ReleaseAllChildren(worker)
    end
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
  end
end

local function StartSpawning(inst)
  if not inst:HasTag("burnt") then
    if inst.components.childspawner and TheWorld.state.iswinter then
      inst.components.childspawner:StartSpawning()
    end
  end
end

local function StopSpawning(inst)
  if not inst:HasTag("burnt") then
    if inst.components.childspawner then
      inst.components.childspawner:StopSpawning()
    end
  end
end

local function OnSpawned(inst, child)
  if not inst:HasTag("burnt") then
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    if TheWorld.state.isday and inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() >= 1 and not child.components.combat.target then
      StopSpawning(inst)
    end
  end
end

local function OnGoHome(inst, child)
  if not inst:HasTag("burnt") then
    inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
    if inst.components.childspawner and inst.components.childspawner:CountChildrenOutside() < 1 then
      StartSpawning(inst)
    end
  end
end

local function onsave(inst, data)
  if inst:HasTag("burnt") or inst:HasTag("fire") then
    data.burnt = true
  end
end

local function onload(inst, data)
  if data and data.burnt then
    inst.components.burnable.onburnt(inst)
  end
end

local function fn()
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  inst.entity:AddNetwork()

  local minimap = inst.entity:AddMiniMapEntity()
  minimap:SetIcon( "mermhouse_fisher.tex" )

  MakeObstaclePhysics(inst, 1)

  inst.AnimState:SetBank("merm_fisherman_house")
  inst.AnimState:SetBuild("merm_fisherman_house")
  inst.AnimState:PlayAnimation("idle")

  inst:AddTag("structure")

  MakeSnowCoveredPristine(inst)

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("lootdropper")
  inst.components.lootdropper:SetLoot(loot)

  inst:AddComponent("workable")
  inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
  inst.components.workable:SetWorkLeft(2)
  inst.components.workable:SetOnFinishCallback(onhammered)
  inst.components.workable:SetOnWorkCallback(onhit)

  inst:AddComponent("childspawner")
  inst.components.childspawner.childname = "mermfisher"
  inst.components.childspawner:SetSpawnedFn(OnSpawned)
  inst.components.childspawner:SetGoHomeFn(OnGoHome)
  inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME*4)
  inst.components.childspawner:SetSpawnPeriod(10)
  inst.components.childspawner:SetMaxChildren(2)

  inst:AddComponent("inspectable")

  inst:ListenForEvent("dusktime", function()
      if not inst:HasTag("burnt") then
        if TheWorld.state.iswinter then
          inst.components.childspawner:ReleaseAllChildren()
        end
        StartSpawning(inst)
      end
    end, TheWorld)

  inst:ListenForEvent("daytime", function() StopSpawning(inst) end , TheWorld)

  inst:ListenForEvent("onignite", function(inst)
      if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
      end
    end)

  inst:ListenForEvent("burntup", function(inst)
      inst.AnimState:PlayAnimation("burnt")
    end)

  MakeMediumBurnable(inst, nil, nil, true)
  MakeLargePropagator(inst)
  MakeSnowCovered(inst, .01)
  StartSpawning(inst)

  return inst
end

return Prefab( "mermhouse_fisher", fn, assets, prefabs)