require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5

local AVOID_PLAYER_DIST = 3
local AVOID_PLAYER_STOP = 6

local SEE_BAIT_DIST = 20
local MAX_WANDER_DIST = 20


local CrabBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function GoHomeAction(inst)
    if inst.components.homeseeker and 
       inst.components.homeseeker.home and 
       inst.components.homeseeker.home:IsValid() and
	   inst.sg:HasStateTag("trapped") == false then
        return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function EatFoodAction(inst)
    local notags = {"FX", "NOCLICK", "DECOR","INLIMBO", "planted", "floating", "aquatic"}
    local target = FindEntity(inst, SEE_BAIT_DIST, function(item) return inst.components.eater:CanEat(item) and item.components.bait and not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) end, nil, notags)

    if target and target.prefab ~= "ice" then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
        return act
    end
end

local function IsDangerClose(inst)
    return FindEntity(inst, 5, nil, {"scarytoprey"}, {'notarget'}) ~= nil
end

local function TryHide(inst)
    if not inst.sg:HasStateTag("busy") then
        return BufferedAction(inst, inst, ACTIONS.CRAB_HIDE)
    end
end

function CrabBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
        --RunAway(self.inst, "scarytopr1ey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
        ParallelNode
        {
            RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST),
            SequenceNode
            {
                WaitNode(5),
                IfNode(function() return IsDangerClose(self.inst) end, "DangerClose", DoAction(self.inst, TryHide, "Hide")),
            },
        },
        EventNode(self.inst, "gohome",
            DoAction(self.inst, GoHomeAction, "go home", true )),
        WhileNode(function() return not TheWorld.state.isday end, "IsNight",
            DoAction(self.inst, GoHomeAction, "go home", true )),
        DoAction(self.inst, EatFoodAction),
        Wander(self.inst, function() return self.inst.components.knownlocations:GetLocation("home") end, MAX_WANDER_DIST)
    }, .25)
    self.bt = BT(self.inst, root)
end

return CrabBrain