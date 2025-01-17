--[[
local function PlayerHasLavae(item)
    return item.components.petleash and item.components.petleash.numpets > 0
end
--]]
local function onboat(self, boat)
    if self.inst.replica.sailor then
        self.inst.replica.sailor._boat:set(boat)
    end
end

local function onsailing(self, sailing)
    if sailing then
        self.inst:AddTag("sailing")
    else
        self.inst:RemoveTag("sailing")
    end
end

local Sailor = Class(function(self, inst)
    self.inst = inst
    self.boat = nil
    self.sailing = false
    self.durabilitymultiplier = 1.0
    self.warningthresholds = --Moved these back to sailor from wisecracker -Z
    {
      { percent = 0.5, string = "ANNOUNCE_BOAT_DAMAGED" },
      { percent = 0.3, string = "ANNOUNCE_BOAT_SINKING" },
      { percent = 0.1, string = "ANNOUNCE_BOAT_SINKING_IMMINENT" },
    }
end, 
nil, 
{
    boat = onboat,
    sailing = onsailing,
})

--[[
function Sailor:HandleFollowers(water)
    local ChangeScene
    if water then
        local entpt

        function ChangeScene(ent)
            if not ent:HasTag("INLIMBO") --is it already removed?
            and not (ent.components.inventoryitem and ent.components.inventoryitem.owner ~= nil)
            and not ent:CanOnWater() then

                SpawnAt("spawn_fx_small", ent)
                ent:RemoveFromScene()
            elseif ent:HasTag("INLIMBO") --is it already removed?
            and not (ent.components.inventoryitem and ent.components.inventoryitem.owner ~= nil)
            and ent:CanOnWater() then

                if not entpt then -- Only do this once, if needed
                    entpt = Vector3(GetNextTickPosition(self.inst, false, TickSpeedToSpeed(3)))
                    SpawnAt("spawn_fx_small", entpt)
                end
                ent.Transform:SetPosition(entpt:Get())
                ent:ReturnToScene()

                if ent.components.spawnfader ~= nil then
                    ent.components.spawnfader:FadeIn()
                end
            end
        end
    else
        local entpt

        function ChangeScene(ent)
            if not ent:HasTag("INLIMBO") --is it already removed?
            and not (ent.components.inventoryitem and ent.components.inventoryitem.owner ~= nil)
            and not ent:CanOnLand() then

                SpawnAt("spawn_fx_small", ent)
                ent:RemoveFromScene()
            elseif ent:HasTag("INLIMBO") --is it already removed?
            and not (ent.components.inventoryitem and ent.components.inventoryitem.owner ~= nil)
            and ent:CanOnLand() then

                if not entpt then -- Only do this once, if needed
                    entpt = Vector3(GetNextTickPosition(self.inst, false, TickSpeedToSpeed(3)))
                    SpawnAt("spawn_fx_small", entpt)
                end
                ent.Transform:SetPosition(entpt:Get())
                ent:ReturnToScene()

                if ent.components.spawnfader ~= nil then
                    ent.components.spawnfader:FadeIn()
                end
            end
        end
    end
    if self.inst.components.inventory ~= nil then
        for k, item in pairs(self.inst.components.inventory.itemslots) do
            if item.components.leader ~= nil then
                for follower, v in pairs(item.components.leader.followers) do
                    ChangeScene(follower)
                end
            end
        end
        --special special case, look inside equipped containers
        for k, equipped in pairs(self.inst.components.inventory.equipslots) do
            if equipped.components.container ~= nil then
                for j, item in pairs(equipped.components.container.slots) do
                    if item.components.leader ~= nil then
                        for follower, v in pairs(item.components.leader.followers) do
                            ChangeScene(follower)
                        end
                    end
                end
            end
        end
    end

    -- This can be an arbitrary number of items
    for i, item in pairs(self.inst.components.inventory:FindItems(PlayerHasLavae)) do
        for j, pet in pairs(item.components.petleash:GetPets()) do
            ChangeScene(pet)
        end
    end

    if self.inst.components.petleash then
        for i, pet in pairs(self.inst.components.petleash:GetPets()) do
            ChangeScene(pet)
        end
    end

    if self.inst.components.leader ~= nil and self.inst.components.leader:CountFollowers() > 0 then
        for follower, v in pairs(self.inst.components.leader.followers) do
            ChangeScene(follower)
        end
    end
end
--]]

function Sailor:GetBoat()
    return self.boat
end

function Sailor:AlignBoat(direction)
    if self.boat then
        local rot = self.inst.Transform:GetRotation()
        self.boat.Transform:SetRotation(rot)
        for visual, v in pairs(self.boat.boatvisuals) do
            visual.Transform:SetRotation(rot)
        end
    end
end

-- This needs to save, because we're removing the boat from the scene
-- to prevent the player from dying upon logging back in.
function Sailor:OnSave()
    local data = {}
    if self.boat ~= nil then
        data.boat = self.boat:GetSaveRecord()
        data.boat.prefab = self.boat.actualprefab or self.boat.prefab
    end
    return data
end

function Sailor:OnLoad(data)
    if data and data.boat ~= nil then
        local boat = SpawnSaveRecord(data.boat)
        if boat then
            self:Embark(boat)
            if boat.components.container then
                boat:DoTaskInTime(0.3, function()
                    if boat.components.container:IsOpen() then
                        boat.components.container:Close(true)
                    end
                end)
                boat:DoTaskInTime(1.5, function()
                    boat.components.container:Open(self.inst)
                end)
            end
        end 
    end
end

function Sailor:OnUpdate(dt)
    if self.boat ~= nil and self.boat:IsValid() then
        if self.boat.components.boathealth then 
            self.boat.components.boathealth.depletionmultiplier = 1.0/self.durabilitymultiplier
        end
        local rot = self.inst.Transform:GetRotation()
        self.boat.Transform:SetRotation(rot)
        for visual, v in pairs(self.boat.boatvisuals) do
            visual.Transform:SetRotation(rot)
        end
    end 
end

function Sailor:Disembark(pos, boat_to_boat)
    self.sailing = false
    self.inst:StopUpdatingComponent(self)

    if self.boat.onboatdelta then
        self.inst:RemoveEventCallback("boathealthchange", self.boat.onboatdelta, self.boat)
        self.boat.onboatdelta = nil
    end
    
    if self.boat.components.container then 
        self.boat.components.container:Close(true)
    end

    if self.inst.components.farseer then
        self.inst.components.farseer:RemoveBonus("boat")
    end

    if self.inst:HasTag("pirate") and self.boat.components.sailable then
        self.boat.components.sailable.sanitydrain = self.cachedsanitydrain
        self.cachedsanitydrain = nil
    end

    self.inst:RemoveChild(self.boat)

    if self.boat.Physics then
        self.boat.Physics:Teleport(self.inst.Transform:GetWorldPosition())
    else
        self.boat.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
    end

    self.inst.components.locomotor.hasmomentum = false

    self.inst.components.locomotor:RemoveExternalSpeedAdder(self.boat, "SAILOR")

    self.inst:RemoveTag("aquatic")
    self.inst:RemoveTag("sailing")
    self.inst:PushEvent("disembarkboat", {target = self.boat, pos = pos, boat_to_boat = boat_to_boat})

    if self.OnDisembarked then
        self.OnDisembarked(self.inst)
    end

    if self.boat.components.sailable then
        self.boat.components.sailable:OnDisembarked(self.inst)
    end

    self.boat = nil

    --self:HandleFollowers(false)

    if pos then
        self.inst.sg:GoToState("jumpoffboatstart", pos)
    elseif boat_to_boat then
        self.inst.sg:GoToState("jumponboatstart")
    end
end

function Sailor:Embark(boat)
    if not boat or boat.components.sailable == nil then
        return
    end

    self.sailing = true
    self.boat = boat

    if self.inst:HasTag("pirate") then
        self.cachedsanitydrain = boat.components.sailable.sanitydrain
        boat.components.sailable.sanitydrain = 0
    end

    self.inst:StartUpdatingComponent(self)

    self.inst.AnimState:OverrideSymbol("flotsam", self.boat.components.sailable.flotsambuild, "flotsam")

    self.inst:AddTag("aquatic")
    self.inst:AddTag("sailing")
    self.inst.sg:GoToState("jumpboatland")

    if self.boat.Physics then
        self.boat.Physics:Teleport(0, -0.1, 0)
    else
        self.boat.Transform:SetPosition(0, -0.1, 0)
    end
    self.inst:AddChild(self.boat)
    
    self.inst.components.locomotor:SetExternalSpeedAdder(boat, "SAILOR", boat.components.sailable.movementbonus)

    self.inst.components.locomotor.hasmomentum = true

    --Listen for boat taking damage, talk if it is!
    boat.onboatdelta = function(boat, data)
        if data then
            local old = data.oldpercent
            local new = data.percent
            local message = nil
            for _, threshold in ipairs(self.warningthresholds) do
                if old > threshold.percent and new <= threshold.percent then
                    message = threshold.string
                end
            end

            if message then
                self.inst:PushEvent("boat_damaged", {message = message})
            end
        end
    end
    self.inst:ListenForEvent("boathealthchange", boat.onboatdelta, boat)

    if boat.components.boathealth then
        local percent = boat.components.boathealth:GetPercent()
        boat.onboatdelta(boat, {oldpercent = 1, percent = percent})
    end

    
    if self.inst.components.farseer and boat.components.sailable and boat.components.sailable:GetMapRevealBonus() then
        self.inst.components.farseer:AddBonus("boat", boat.components.sailable:GetMapRevealBonus())
    end
    

    if boat.components.container then
        if boat.components.container:IsOpen() then
            boat.components.container:Close(true)
        end
        boat:DoTaskInTime(0.25, function() boat.components.container:Open(self.inst) end)
    end

    --self:HandleFollowers(true)

    self.inst:PushEvent("embarkboat", {target = self.boat})

    if self.OnEmbarked then 
        self.OnEmbarked(self.inst)
    end

    if self.boat.components.sailable then
        self.boat.components.sailable:OnEmbarked(self.inst)
    end
end

function Sailor:IsSailing()
    return self.sailing and self.boat ~= nil
end

return Sailor