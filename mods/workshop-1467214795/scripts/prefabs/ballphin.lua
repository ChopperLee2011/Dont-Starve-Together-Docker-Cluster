local assets =
{
  Asset("ANIM", "anim/ballphin.zip"),
}

local prefabs =
{
  "fish_med",
  "fish_small",
  "messagebottleempty",
  "splash_water_drop",
  "ballphinpod",
  "dorsalfin",
}

local function ontalk(inst, script)
  inst.SoundEmitter:PlaySound("ia/creatures/balphin/taunt")
end

local brain = require "brains/ballphinbrain"


local SHARE_TARGET_DIST = 30

local function OnNewTarget(inst, data)
  if inst.components.sleeper:IsAsleep() then
    inst.components.sleeper:WakeUp()
  end
end

local function retargetfn(inst)
  local dist = TUNING.BALLPHIN_TARGET_DIST
  return FindEntity(inst, dist, function(guy) 
      --return not guy:HasTag("wall") and not (guy:HasTag("ballphin") ) and inst.components.combat:CanTarget(guy)
      return guy.components.health and not guy.components.health:IsDead()
      and inst.components.combat:CanTarget(guy)
    end, {"monster"}, {"abigail"})
end

local function KeepTarget(inst, target)
  if inst:HasTag('ballphinfriend') then
    return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= (40*40)
  else
    return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= (TUNING.BALLPHIN_KEEP_TARGET_DIST*TUNING.BALLPHIN_KEEP_TARGET_DIST)
  end
end

local function OnAttacked(inst, data)
  inst.components.combat:SetTarget(data.attacker)
  inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("ballphin")and not dude.components.health:IsDead() end, 5)
end

local function OnAttackOther(inst, data)
  inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("ballphin") and not dude.components.health:IsDead() end, 5)
  -- local splash = SpawnPrefab("splash_water_drop")
  -- local pos = inst:GetPosition()
  -- splash.Transform:SetPosition(pos.x, pos.y, pos.z)
end

local function CalcSanityAura(inst, observer)

  if inst.components.follower and inst.components.follower.leader == observer and inst.entity:IsVisible() then
    return TUNING.SANITYAURA_MED
  end

  return 0
end

local function ShouldAcceptItem(inst, item)
  if inst.components.sleeper:IsAsleep() then
    return false
  end

  if item.components.edible then

    if item.components.edible.foodtype == "MEAT" then
      if not item:HasTag("fishmeat") then
        return false
      end
      if inst.components.follower.leader and inst.components.follower:GetLoyaltyPercent() > 0.9 then
        return false
      end
    end

    if item.components.edible.foodtype == "VEGGIE" then
      -- print("being given food veggie")
      if not item:HasTag("hydrofarm") then
        return false
      end

      local last_eat_time = inst.components.eater:TimeSinceLastEating()
      if last_eat_time and last_eat_time < TUNING.BALLPHIN_MIN_POOP_PERIOD then
        return false
      end
    end

    return true
  end
end

local function OnGetItemFromPlayer(inst, giver, item)
  --I eat food
  if item.components.edible then

    --meat makes us friends (unless I'm a guard)
    if item:HasTag("fishmeat") then

      if inst.components.combat.target and inst.components.combat.target == giver then
        inst.components.combat:SetTarget(nil)
      elseif giver.components.leader and not inst:HasTag("guard") then
        inst.SoundEmitter:PlaySound("dontstarve/common/makeFriend")
        giver.components.leader:AddFollower(inst)
        local loyaltytime = math.min(TUNING.BALLPHIN_LOYALTY_MAX_TIME, item.components.edible:GetHunger() * TUNING.BALLPHIN_LOYALTY_PER_HUNGER)
        inst.components.follower:AddLoyaltyTime(loyaltytime)
      end

    end

    if inst.components.sleeper:IsAsleep() then
      inst.components.sleeper:WakeUp()
    end
  end

end

local function OnEat(inst, food)

end

local function OnRefuseItem(inst, item)
  --inst.sg:GoToState("refuse")
  if inst.components.sleeper:IsAsleep() then
    inst.components.sleeper:WakeUp()
  end
end

local function preventdrowningtest(inst, leader)
	return inst:IsNear(leader, 32)
	and math.random() < TUNING.BALLPHIN_DROWN_RESCUE_CHANCE
end

local function fn()

  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddNetwork()

  --local minimap = inst.entity:AddMiniMapEntity()
  --minimap:SetIcon( "fish.tex" )

  inst:AddTag("ballphin")
  inst:AddTag("aquatic")

  MakeCharacterPhysics(inst, 1, 0.5)
  -- inst.Physics:ClearCollisionMask()
  -- inst.Physics:CollidesWith(COLLISION.WORLD)
  inst.entity:AddSoundEmitter()

  inst.Transform:SetFourFaced()

  inst.entity:AddLightWatcher()

  inst.entity:SetPristine()

  if not TheWorld.ismastersim then
    return inst
  end

  inst:AddComponent("locomotor")
  inst.components.locomotor.walkspeed = TUNING.SOLOFISH_WALK_SPEED -- 2--3.0
  inst.components.locomotor.runspeed = TUNING.SOLOFISH_RUN_SPEED--5--6.0 

  inst:SetStateGraph("SGballphin")
  inst:SetBrain(brain)

  inst.AnimState:SetBank("ballphin")
  inst.AnimState:SetBuild("ballphin")  
  inst.AnimState:PlayAnimation("idle", true)

  inst:AddComponent("eater")
  inst.components.eater:SetOmnivore()
  inst.components.eater:SetCanEatHorrible()
  table.insert(inst.components.eater.preferseating, FOODTYPE.RAW)
  table.insert(inst.components.eater.caneat, FOODTYPE.RAW)
  inst.components.eater.strongstomach = true -- can eat monster meat!
  inst.components.eater:SetOnEatFn(OnEat)

  inst.AnimState:SetRayTestOnBB(true)

  inst:AddComponent("inspectable")
  inst.no_wet_prefix = true

  inst:AddComponent("herdmember")
  inst.components.herdmember.herdprefab = "ballphinpod"

  inst:AddComponent("teamattacker")
  inst.components.teamattacker.team_type = "ballphin"
  inst.components.teamattacker.leashdistance = 99999

  inst:AddComponent("knownlocations")

  inst:AddComponent("combat")
  inst.components.combat:SetDefaultDamage(TUNING.BALLPHIN_DAMAGE)
  inst.components.combat:SetAttackPeriod(TUNING.BALLPHIN_ATTACK_PERIOD)
  inst.components.combat:SetRetargetFunction(3, retargetfn)
  inst.components.combat:SetKeepTargetFunction(KeepTarget)
  inst.components.combat:SetHurtSound("ia/creatures/balphin/hit")	

  inst:AddComponent("health")
  inst.components.health:SetMaxHealth(TUNING.BALLPHIN_HEALTH)

  inst:AddComponent("inventory")

  inst:AddComponent("named")
  inst.components.named.possiblenames = STRINGS.BALLPHINNAMES
  inst.components.named:PickNewName()

  inst:AddComponent("follower")
  inst.components.follower.maxfollowtime = TUNING.BALLPHIN_LOYALTY_MAX_TIME
  inst.components.follower:SetFollowExitDestinations({EXIT_DESTINATION.WATER})
  inst.components.follower.preventdrowningtest = preventdrowningtest


  inst:AddComponent("talker")
  inst.components.talker.ontalk = ontalk
  inst.components.talker.fontsize = 35
  inst.components.talker.font = TALKINGFONT
  inst.components.talker.offset = Vector3(0,-400,0)

  inst:AddComponent("trader")
  inst.components.trader:SetAcceptTest(ShouldAcceptItem)
  inst.components.trader.onaccept = OnGetItemFromPlayer
  inst.components.trader.onrefuse = OnRefuseItem

  inst:AddComponent("sanityaura")
  inst.components.sanityaura.aurafn = CalcSanityAura

  inst:AddComponent("sleeper")

  inst:AddComponent("lootdropper")
  inst.components.lootdropper:SetLoot({"fish_small", "fish_small", "dorsalfin"})
  inst.components.lootdropper:AddChanceLoot("messagebottleempty", TUNING.SNAKE_JUNGLETREE_CHANCE)

  inst:ListenForEvent("newcombattarget", OnNewTarget)
  inst:ListenForEvent("attacked", OnAttacked)
  inst:ListenForEvent("onattackother", OnAttackOther)
  inst:ListenForEvent("explosion", function(it, data)
      if inst.brain then
        inst.brain.afraid = true
        inst:DoTaskInTime(TUNING.SEG_TIME, function(inst)
            if inst and inst.brain then
              inst.brain.afraid = false
            end
          end)
      end
    end, TheWorld)
  inst:ListenForEvent("lightningstart", function(it, data)
      if inst.brain then
        inst.brain.afraid = true
        inst:DoTaskInTime(TUNING.SEG_TIME, function(inst)
            if inst and inst.brain then
              inst.brain.afraid = false
            end
          end)
      end
    end, TheWorld)

  MakeMediumFreezableCharacter(inst, "ballphin_body")

  return inst
end

return Prefab( "ballphin", fn, assets, prefabs)