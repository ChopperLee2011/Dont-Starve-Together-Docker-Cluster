local ObsidianTool = Class(function(self, inst)
    self.inst = inst

    --V2C: Recommended to explicitly add tag to prefab pristine state
    inst:AddTag("obsidiantool")

    self.charge = 0
    self.maxcharge = TUNING.OBSIDIAN_TOOL_MAXCHARGES
    self.cooldowntime = TUNING.TOTAL_DAY_TIME / TUNING.OBSIDIAN_TOOL_MAXCHARGES
    self.cooltimer = 0

    self.red_threshold = 0.90
    self.orange_threshold = 0.66
    self.yellow_threshold = 0.33
    self.normal_threshold = 0.01
    self.tool_type = ""
end)

function ObsidianTool:Start()
	self.inst:StartUpdatingComponent(self)
end

function ObsidianTool:Stop()
	self.inst:StopUpdatingComponent(self)
end

function ObsidianTool:OnSave()
	return {charge = self.charge}
end

function ObsidianTool:OnLoad(data)
	self:SetCharge(data.charge or 0)
end

function ObsidianTool:GetCharge()
	return self.charge, self.maxcharge
end

function ObsidianTool:SetCharge(num)
	local old = self.charge
	self.charge = num

	if self.charge > 0 then
		self:Start()
	else
		self:Stop()
	end

	self.inst:PushEvent("obsidianchargechange", {percent = self.charge / self.maxcharge})

	self:OnChargeDelta(old, self.charge)
end

function ObsidianTool:Ignite(doer, target)
	if target.SoundEmitter then
		target.SoundEmitter:PlaySound("dontstarve/wilson/blowdart_impact_fire")
	end
	if target.components.burnable then
		target.components.burnable:Ignite()
	end
	if target.components.propagator then
		target.components.propagator:Flash()
	end
	if target.components.health then
		target.components.health:DoFireDamage(0)
	end
end

function ObsidianTool:Use(doer, target)
    --print("Executing ObsidianTool:Use")
	if TheWorld.state.iswinter or TheWorld.state.iswet then
		self:SetCharge(0)
		if self.inst.SoundEmitter then
			self.inst.SoundEmitter:PlaySound("ia/common/obsidian_wetsizzles")
		end
	else
		self:SetCharge(math.min(self.charge + 1, self.maxcharge))
		if self.charge >= self.maxcharge then
			self:Ignite(doer, target)
		end
		self.cooltimer = 0.0
	end
end

function ObsidianTool:OnUpdate(dt)
	self.cooltimer = self.cooltimer + dt
	if self.cooltimer >= self.cooldowntime then
		self:SetCharge(math.max(self.charge - 1, 0))
		self.cooltimer = 0.0
	end
end

local function getAnimSuffix(self, percentage)
	if percentage >= self.red_threshold then
		return "_red"
	elseif percentage >= self.orange_threshold then
		return "_orange"
	elseif percentage >= self.yellow_threshold then
		return "_yellow"
	else
		return ""
	end
end

function ObsidianTool:OnChargeDelta(old, new)
	local equipper = nil

	if self.inst.components.equippable and self.inst.components.equippable:IsEquipped() and self.inst.components.inventoryitem then
		equipper = self.inst.components.inventoryitem:GetGrandOwner()
	end

	local percentage = new/self.maxcharge
	local suffix = getAnimSuffix(self, percentage)

	-- self.inst.AnimState:PlayAnimation("idle"..suffix)
	self.inst.components.floater:UpdateAnimations("idle_water"..suffix, "idle"..suffix)

	if equipper then
		equipper.AnimState:OverrideSymbol("swap_object", "swap_"..self.tool_type.."_obsidian", "swap_"..self.tool_type..suffix)
	end

	if self.onchargedelta then
		self.onchargedelta(self.inst, old, new)
	end
end

return ObsidianTool