local TUNING = GLOBAL.TUNING

local _DefaultBurntStructureFn = GLOBAL.DefaultBurntStructureFn
function GLOBAL.DefaultBurntStructureFn(inst)
  _DefaultBurntStructureFn(inst)
  if inst.components.floodable then 
    inst:RemoveComponent("floodable")
  end 
end

function GLOBAL.MakeInvItemIA(inst, image)
    inst:AddComponent("inventoryitem")
    -- inst.components.inventoryitem.atlasname = 'images/ia_inventoryimages.xml'
    inst.components.inventoryitem.imagename = image
end

--Amphibious

local COLLISION = GLOBAL.COLLISION

local _ChangeToGhostPhysics = GLOBAL.ChangeToGhostPhysics
function GLOBAL.ChangeToGhostPhysics(inst, ...)
    local phys = _ChangeToGhostPhysics(inst, ...) or inst.Physics
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

local _ChangeToCharacterPhysics = GLOBAL.ChangeToCharacterPhysics
function GLOBAL.ChangeToCharacterPhysics(inst, ...)
    local phys = _ChangeToCharacterPhysics(inst, ...) or inst.Physics
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

local _ChangeToObstaclePhysics = GLOBAL.ChangeToObstaclePhysics
function GLOBAL.ChangeToObstaclePhysics(inst, ...)
    local phys = _ChangeToObstaclePhysics(inst, ...) or inst.Physics
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

function GLOBAL.ChangeToUnderwaterCharacterPhysics(inst)
	local phys = inst.Physics
    phys:SetCollisionGroup(COLLISION.CHARACTERS)
    phys:ClearCollisionMask()
    phys:CollidesWith(COLLISION.WORLD)
	return phys
end

function GLOBAL.MakeUnderwaterCharacterPhysics(inst, mass, rad)
	local phys = inst.entity:AddPhysics()
	phys:SetMass(mass)
	phys:SetCapsule(rad, 1)
	phys:SetFriction(0)
	phys:SetDamping(5)
	phys:SetCollisionGroup(COLLISION.CHARACTERS)
	phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.WORLD)
	return phys
end

function GLOBAL.MakeAmphibiousCharacterPhysics(inst, mass, rad)
	local phys = inst.entity:AddPhysics()
	phys:SetMass(mass)
	phys:SetCapsule(rad, 1)
	phys:SetFriction(0)
	phys:SetDamping(5)
	phys:SetCollisionGroup(COLLISION.CHARACTERS)
	phys:ClearCollisionMask()
	phys:CollidesWith(COLLISION.WORLD)
	phys:CollidesWith(COLLISION.OBSTACLES)
	phys:CollidesWith(COLLISION.CHARACTERS)
	phys:CollidesWith(COLLISION.WAVES)
	inst:AddTag("amphibious")
	return phys
end

-- Wave Collision patches

local _MakeCharacterPhysics = GLOBAL.MakeCharacterPhysics
function GLOBAL.MakeCharacterPhysics(...)
    local phys = _MakeCharacterPhysics(...)
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

local _MakeGhostPhysics = GLOBAL.MakeGhostPhysics
function GLOBAL.MakeGhostPhysics(...)
    local phys = _MakeGhostPhysics(...)
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

local _MakeObstaclePhysics = GLOBAL.MakeObstaclePhysics
function GLOBAL.MakeObstaclePhysics(...)
    local phys = _MakeObstaclePhysics(...)
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

local _MakeSmallObstaclePhysics = GLOBAL.MakeSmallObstaclePhysics
function GLOBAL.MakeSmallObstaclePhysics(...)
    local phys = _MakeSmallObstaclePhysics(...)
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

local _MakeHeavyObstaclePhysics = GLOBAL.MakeHeavyObstaclePhysics
function GLOBAL.MakeHeavyObstaclePhysics(...)
    local phys = _MakeHeavyObstaclePhysics(...)
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

local _MakeSmallHeavyObstaclePhysics = GLOBAL.MakeSmallHeavyObstaclePhysics
function GLOBAL.MakeSmallHeavyObstaclePhysics(...)
    local phys = _MakeSmallHeavyObstaclePhysics(...)
    phys:CollidesWith(COLLISION.WAVES)
	return phys
end

-- Poison

function GLOBAL.MakeAreaPoisoner(inst, poisonrange)
  inst:AddComponent("areapoisoner")
  inst.components.areapoisoner.poisonrange = poisonrange or 0
end

function GLOBAL.MakePoisonableCharacter(inst, sym, offset, fxstyle, damage_penalty, attack_period_penalty, speed_penalty, hunger_burn, sanity_scale)
  inst:AddComponent("poisonable")
  inst:AddTag("poisonable")
  inst.components.poisonable:AddPoisonFX("poisonbubble", offset or GLOBAL.Vector3(0, 0, 0), sym)

  if fxstyle == nil or fxstyle == "loop" then
    inst.components.poisonable.show_fx = true
    inst.components.poisonable.loop_fx = true
  elseif fxstyle == "none" then
    inst.components.poisonable.show_fx = false
    inst.components.poisonable.loop_fx = false
  elseif fxstyle == "player" then
    inst.components.poisonable.show_fx = true
    inst.components.poisonable.loop_fx = false
  end


  inst.components.poisonable:SetOnPoisonedFn(function()
      if inst.player_classified then inst.player_classified.ispoisoned:set(true) end

      if inst.components.combat then
        inst.components.combat:AddDamageModifier("poison", damage_penalty or TUNING.POISON_DAMAGE_MOD)
        inst.components.combat:AddPeriodModifier("poison", attack_period_penalty or TUNING.POISON_ATTACK_PERIOD_MOD)
      end

      if inst.components.locomotor then
        inst.components.locomotor:SetExternalSpeedMultiplier(inst, "poison", speed_penalty or TUNING.POISON_SPEED_MOD)
      end

      if inst.components.hunger then
        inst.components.hunger.burnratemodifiers:SetModifier(inst, hunger_burn or TUNING.POISON_HUNGER_DRAIN_MOD, "poison")
      end

      if inst.components.sanity then
        inst.components.sanity.externalmodifiers:SetModifier(inst, -inst.components.poisonable.damage_per_interval * (sanity_scale or TUNING.POISON_SANITY_SCALE), "poison")
      end

    end)

  inst.components.poisonable:SetOnPoisonDoneFn(function()
      if inst.player_classified then inst.player_classified.ispoisoned:set(false) end

      if inst.components.combat then
        inst.components.combat:RemoveDamageModifier("poison")
        inst.components.combat:RemovePeriodModifier("poison")
      end

      if inst.components.locomotor then
        inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "poison")
      end

      if inst.components.hunger then
        inst.components.hunger.burnratemodifiers:RemoveModifier(inst, "poison")
      end

      if inst.components.sanity then
        inst.components.sanity.externalmodifiers:RemoveModifier(inst, "poison")
      end

    end)

  inst.components.poisonable:SetOnCuredFn(function()

    end)
end

function GLOBAL.MakePoisonousEntity(inst, strength)
  inst:AddTag("poisonous")

  inst.components.combat.poisonous = true
  inst.components.combat.poisonstrength = strength or 1.00
end

-- Wind

function GLOBAL.MakeBlowInHurricane(inst, minscale, maxscale)
	if inst.components.blowinwindgustitem == nil then
		inst:AddComponent("blowinwindgustitem")
	end

	inst.components.blowinwindgustitem:SetAverageSpeed(TUNING.WILSON_RUN_SPEED - 1)
	inst.components.blowinwindgustitem:SetMaxSpeedMult(maxscale or 1.0)
	inst.components.blowinwindgustitem:SetMinSpeedMult(minscale or 0.1)
	inst.components.blowinwindgustitem:Start()
end

function GLOBAL.RemoveBlowInHurricane(inst)
	inst:RemoveComponent("blowinwindgustitem")
end

local function ongustpick(inst)
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		if inst.components.blowinwindgust.animdata then
			inst.AnimState:SetBank(inst.components.blowinwindgust.animdata.bankidle)
			if inst.components.blowinwindgust.animdata.buildidle then
				inst.AnimState:SetBuild(inst.components.blowinwindgust.animdata.buildidle)
			end
		end
		inst.components.pickable:Pick(inst) --GitLab issue #214 (Not TheLocalPlayer either, due to #220)
		--no picker with inventory means no loot, simulate!
		if inst.components.lootdropper ~= nil and inst.components.pickable.product ~= nil then
			for i = 1, inst.components.pickable.numtoharvest or 1 do
				inst.components.lootdropper:SpawnLootPrefab(inst.components.pickable.product)
			end
		end
	end
end
local function ongusthack(inst)
	if inst.components.hackable and inst.components.hackable:CanBeHacked() then
		if inst.components.blowinwindgust.animdata then
			inst.AnimState:SetBank(inst.components.blowinwindgust.animdata.bankidle)
			if inst.components.blowinwindgust.animdata.buildidle then
				inst.AnimState:SetBuild(inst.components.blowinwindgust.animdata.buildidle)
			end
		end
		inst.components.hackable:Hack(inst, inst.components.hackable.hacksleft) --GitLab issue #214 (Not TheLocalPlayer either, due to #220)
	end
end
local function ongustchop(inst)
	if inst.components.workable then
		inst.components.workable:Destroy(inst) --TODO GitLab issue #214 (Not TheLocalPlayer either, due to #220)
	end
end
local function ongustanimdone(inst)
	if inst.components.pickable and inst.components.pickable:CanBePicked()
	or inst.components.hackable and inst.components.hackable:CanBeHacked() then
		if inst.components.blowinwindgust:IsGusting() then
			local anim = math.random(1,2)
			inst.AnimState:PlayAnimation("blown_loop"..anim, false)
		else
			inst:DoTaskInTime(math.random()/2, function(inst)
				inst:RemoveEventCallback("animover", ongustanimdone)
				inst.AnimState:PlayAnimation("blown_pst", false)
				inst.AnimState:PushAnimation("idle", true)
				if inst.components.blowinwindgust.animdata then
					inst:DoTaskInTime(3, function(inst) --This really is isgusting X<  -M
						if not inst.components.blowinwindgust:IsGusting() then
							inst.AnimState:SetBank(inst.components.blowinwindgust.animdata.bankidle)
							if inst.components.blowinwindgust.animdata.buildidle then
								inst.AnimState:SetBuild(inst.components.blowinwindgust.animdata.buildidle)
							end
						end
					end)
				end
			end)
		end
	else
		inst:RemoveEventCallback("animover", ongustanimdone)
	end
end
local function onguststart(inst, windspeed)
	if inst.components.pickable and inst.components.pickable:CanBePicked()
	or inst.components.hackable and inst.components.hackable:CanBeHacked() then
		inst:DoTaskInTime(math.random()/2, function(inst)
			if inst.components.blowinwindgust.animdata then
				inst.AnimState:SetBank(inst.components.blowinwindgust.animdata.bankgust)
				if inst.components.blowinwindgust.animdata.buildgust then
					inst.AnimState:SetBuild(inst.components.blowinwindgust.animdata.buildgust)
				end
			end
			inst.AnimState:PlayAnimation("blown_pre", false)
			inst:ListenForEvent("animover", ongustanimdone)
		end)
	end
end
local function ongustanimdonetree(inst)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		inst:RemoveEventCallback("animover", ongustanimdonetree)
		return
	end
	if inst.components.blowinwindgust and inst.components.blowinwindgust:IsGusting() then
		local anim = math.random(1,2)
		inst.AnimState:PlayAnimation(inst.anims["blown"..tostring(anim)], false)
		inst.SoundEmitter:PlaySound("ia/common/wind_tree_creak") --I won't bother with the spot emitters -M
	else
		inst:DoTaskInTime(math.random()/2, function(inst)
			inst:RemoveEventCallback("animover", ongustanimdonetree)
			inst.AnimState:PlayAnimation(inst.anims.blown_pst, false)
			inst:PushSway()
		end)
	end
end
local function onguststarttree(inst, windspeed)
	if inst:HasTag("stump") or inst:HasTag("burnt") then
		return
	end
	inst:DoTaskInTime(math.random()/2, function(inst)
		-- if inst.spotemitter == nil then
			-- AddToNearSpotEmitter(inst, "treeherd", "tree_creak_emitter", TUNING.TREE_CREAK_RANGE)
		-- end
		inst.AnimState:PlayAnimation(inst.anims.blown_pre, false)
		inst.SoundEmitter:PlaySound("ia/common/wind_tree_creak")
		inst:ListenForEvent("animover", ongustanimdonetree)
	end)
end
  
function GLOBAL.MakePickableBlowInWindGust(inst, wind_speed, destroy_chance, animdata)
  inst:AddComponent("blowinwindgust")
  inst.components.blowinwindgust:SetWindSpeedThreshold(wind_speed)
  inst.components.blowinwindgust:SetDestroyChance(destroy_chance)
  inst.components.blowinwindgust.animdata = animdata --special data for incomptabile SW anim
  inst.components.blowinwindgust:SetGustStartFn(onguststart)
  inst.components.blowinwindgust:SetDestroyFn(ongustpick)
  inst.components.blowinwindgust:Start()
end

function GLOBAL.MakeHackableBlowInWindGust(inst, wind_speed, destroy_chance)
  inst:AddComponent("blowinwindgust")
  inst.components.blowinwindgust:SetWindSpeedThreshold(wind_speed)
  inst.components.blowinwindgust:SetDestroyChance(destroy_chance)
  inst.components.blowinwindgust:SetGustStartFn(onguststart)
  inst.components.blowinwindgust:SetDestroyFn(ongusthack)
  inst.components.blowinwindgust:Start()
end

function GLOBAL.MakeTreeBlowInWindGust(inst, wind_speed, destroy_chance)
  inst:AddComponent("blowinwindgust")
  inst.components.blowinwindgust:SetWindSpeedThreshold(wind_speed)
  inst.components.blowinwindgust:SetDestroyChance(destroy_chance)
  inst.components.blowinwindgust:SetGustStartFn(onguststarttree)
  inst.components.blowinwindgust:SetDestroyFn(ongustchop)
  inst.components.blowinwindgust:Start()
end

-- Obsidian tools

local function GetObsidianHeat(inst, observer)
    local charge, maxcharge = inst.components.obsidiantool:GetCharge()
    local heat = GLOBAL.Lerp(0, TUNING.OBSIDIAN_TOOL_MAXHEAT, charge / maxcharge)
    return heat
end

local function GetObsidianEquippedHeat(inst, observer)
    local heat = GetObsidianHeat(inst, observer)
    heat = math.clamp(heat, 0, TUNING.OBSIDIAN_TOOL_MAXHEAT)
    --awkward/hacky but safer
    if inst.components.temperature then
        local current = inst.components.temperature:GetCurrent()
        if heat > current then
            heat = heat + current
        elseif heat < current then
            heat = current --cancel out heat so tools don't cool you down
        end
    end
    return heat
end

local function SpawnObsidianLight(inst)
    local owner = inst.components.inventoryitem.owner
    inst._obsidianlight = inst._obsidianlight or GLOBAL.SpawnPrefab("obsidiantoollight")
    inst._obsidianlight.entity:SetParent((owner or inst).entity)
end

local function RemoveObsidianLight(inst)
    if inst._obsidianlight ~= nil then
        inst._obsidianlight:Remove()
        inst._obsidianlight = nil
    end
end

local function ChangeObsidianLight(inst, old, new)
    local percentage = new / inst.components.obsidiantool.maxcharge
    local rad = GLOBAL.Lerp(1, 2.5, percentage)

    if percentage >= inst.components.obsidiantool.yellow_threshold then
        SpawnObsidianLight(inst)

        if percentage >= inst.components.obsidiantool.red_threshold then
            inst._obsidianlight.Light:SetColour(254/255,98/255,75/255)
            inst._obsidianlight.Light:SetRadius(rad)
        elseif percentage >= inst.components.obsidiantool.orange_threshold then
            inst._obsidianlight.Light:SetColour(255/255,159/255,102/255)
            inst._obsidianlight.Light:SetRadius(rad)
        else
            inst._obsidianlight.Light:SetColour(255/255,223/255,125/255)
            inst._obsidianlight.Light:SetRadius(rad)
        end
    else
        RemoveObsidianLight(inst)
    end
end

local function ManageObsidianLight(inst)
    local cur, max = inst.components.obsidiantool:GetCharge() 
    if cur / max >= inst.components.obsidiantool.yellow_threshold then
        SpawnObsidianLight(inst)
    else
        RemoveObsidianLight(inst)
    end
end

local function ObsidianToolAttack(inst, attacker, target)
    local charge, maxcharge = inst.components.obsidiantool:GetCharge()
    local damage_mod = GLOBAL.Lerp(0, 1, charge / maxcharge) --Deal up to double damage based on charge.

    target.components.combat:GetAttacked(attacker, attacker.components.combat:CalcDamage(target, inst, damage_mod), inst, "FIRE")

    --light target on fire if at maximum heat.
    if charge == maxcharge then
        if target.components.burnable then
            target.components.burnable:Ignite()
        end
    end
end

local function ObsidianToolHitWater(inst)
    if inst.SoundEmitter then inst.SoundEmitter:PlaySound("ia/common/obsidian_wetsizzles") end
    inst.components.obsidiantool:SetCharge(0)
end

function GLOBAL.MakeObsidianToolPristine(inst)
    inst:AddTag("obsidian")
    inst:AddTag("notslippery")
    inst.no_wet_prefix = true

    --obsidiantool (from obsidiantool component) added to pristine state for optimization
    inst:AddTag("obsidiantool")
end

function GLOBAL.MakeObsidianTool(inst, tooltype)
    inst:AddComponent("obsidiantool")
    inst.components.obsidiantool.tool_type = tooltype

    inst.components.obsidiantool.onchargedelta = ChangeObsidianLight
    inst:ListenForEvent("equipped", ManageObsidianLight)
    inst:ListenForEvent("onputininventory", ManageObsidianLight)
    inst:ListenForEvent("ondropped", ManageObsidianLight)

    if not inst.components.heater then
        --only hook up heater to obsidiantool if the heater isn't already on.
        inst:AddComponent("heater")
        inst.components.heater.show_heat = true

        inst.components.heater.heatfn = GetObsidianHeat
        inst.components.heater.minheat = 0
        inst.components.heater.maxheat = TUNING.OBSIDIAN_TOOL_MAXHEAT

        inst.components.heater.equippedheatfn = GetObsidianEquippedHeat

        inst.components.heater.carriedheatfn = GetObsidianHeat
        inst.components.heater.mincarriedheat = 0
        inst.components.heater.maxcarriedheat = TUNING.OBSIDIAN_TOOL_MAXHEAT
    end

    if inst.components.weapon then
        if inst.components.weapon.onattack then
            print("Obsidian Weapon", inst, "already has an onattack!")
        else
            inst.components.weapon:SetOnAttack(ObsidianToolAttack)
        end
    end

	inst:ListenForEvent("floater_startfloating", ObsidianToolHitWater)
end

local TogglePickable = GLOBAL.UpvalueHacker.GetUpvalue(GLOBAL.MakeNoGrowInWinter, "TogglePickable")
local TogglePickable_IA = function(inst)
	TogglePickable(inst.components.pickable, GLOBAL.TheWorld.state.iswinter and not GLOBAL.IsInIAClimate(inst))
end
GLOBAL.UpvalueHacker.SetUpvalue(GLOBAL.MakeNoGrowInWinter, function(pickable, iswinter)
	if pickable.inst:GetPosition():LengthSq() == 0 then --almost certainly not placed yet
		pickable.inst:DoTaskInTime(0, TogglePickable_IA)
	else
		return TogglePickable(pickable, iswinter and not GLOBAL.IsInIAClimate(pickable.inst))
	end
end, "TogglePickable")
