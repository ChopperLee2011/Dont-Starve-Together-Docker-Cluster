local assets=
{
  Asset("ANIM", "anim/seashell.zip"),
}


local prefabs =
{
  "seashell",
}    


--local names = {"f1","f2","f3","f4","f5","f6","f7","f8","f9","f10"}

local function onpickedfn(inst, picker)
  if picker and picker.components.sanity then
    picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
    --print("up the sanity!")
  end	
  inst.hidden = true 
  inst:Hide()
  inst:AddTag("NOCLICK")
end


local function checktide(inst)
  local flooding = TheWorld.components.flooding 
  if flooding and flooding.mode == "tides" then 
    if inst:GetIsFlooded() then 

      if inst.tideTask then
        inst.tideTask:Cancel()
        inst.tideTask= nil
      end
      inst.hidden = false 
      inst:Show()
      inst.AnimState:PlayAnimation("appear")
      inst.AnimState:PushAnimation("buried")
      inst:RemoveTag("NOCLICK")
    end 
  end 
end 

local function beginTideCheckTask(inst)
  if inst.tideTask then
    inst.tideTask:Cancel()
    inst.tideTask= nil
  end
  local period = 5
  inst.tideTask = inst:DoPeriodicTask(period, checktide)
end 


local function onregenfn(inst)
  beginTideCheckTask(inst)
end 


local function onload(inst, data)
  if data then 
    if data.hidden then 
      inst.hidden = true 
      inst:Hide()
      inst:AddTag("NOCLICK")
      if data.waitingfortide then 
        beginTideCheckTask(inst)
      end 
    else 
      inst.hidden = false 
    end 
  else 
    inst.hidden = false
    --inst:Hide()
    --inst:AddTag("NOCLICK")
    --beginTideCheckTask(inst)

  end 
end 


local function onsave(inst, data)
  data.hidden = inst.hidden
  data.waitingfortide = inst.tideTask ~= nil 
end 


local function fn(Sim)
  local inst = CreateEntity()
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  inst.AnimState:SetBank("seashell")
  inst.AnimState:SetBuild("seashell")
  inst.AnimState:PlayAnimation("buried")
  inst.AnimState:SetRayTestOnBB(true);

  inst:AddTag("seashell")

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("inspectable")

  inst:AddComponent("pickable")
  inst.components.pickable.picksound = "ia/common/shell_harvest"
  inst.components.pickable:SetUp("seashell", TUNING.SEASHELL_REGEN_TIME)
  inst.components.pickable.onpickedfn = onpickedfn
  inst.components.pickable.onregenfn = onregenfn
  inst.components.pickable.quickpick = true
  inst.components.pickable.wildfirestarter =false
  --inst.hidden = true

  inst.OnSave = onsave
  inst.OnLoad = onload
  --inst:Hide()
  --inst:AddTag("NOCLICK")
  --beginTideCheckTask(inst)

  --------SaveLoad
  --inst.OnSave = onsave 
  --inst.OnLoad = onload 

  return inst
end

return Prefab( "seashell_beached", fn, assets, prefabs) 
