local assets =
{
	Asset("ANIM", "anim/lantern_bottle.zip"),
	Asset("ANIM", "anim/swap_bottlle_lantern.zip"),
}

local prefabs =
{
	"bottlelanternlight",
}

local function DoTurnOffSound(inst, owner)
	inst._soundtask = nil
	(owner ~= nil and owner:IsValid() and owner.SoundEmitter or inst.SoundEmitter):PlaySound("ia/common/bottlelantern_turnoff")
end

local function PlayTurnOffSound(inst)
	if inst._soundtask == nil and inst:GetTimeAlive() > 0 then
		inst._soundtask = inst:DoTaskInTime(0, DoTurnOffSound, inst.components.inventoryitem.owner)
	end
end

local function PlayTurnOnSound(inst)
	if inst._soundtask ~= nil then
		inst._soundtask:Cancel()
		inst._soundtask = nil
	elseif not POPULATING then
		inst._light.SoundEmitter:PlaySound("ia/common/bottlelantern_turnon")
	end
end

local function fuelupdate(inst)
	if inst._light ~= nil then
		local fuelpercent = inst.components.fueled:GetPercent()
		inst._light.Light:SetIntensity(Lerp(.4, .65, fuelpercent))
		inst._light.Light:SetRadius(Lerp(3, 5, fuelpercent))
		inst._light.Light:SetFalloff(.9)
	end
end

local function onremovelight(light)
	light._lantern._light = nil
end

local function stoptrackingowner(inst)
	if inst._owner ~= nil then
		inst:RemoveEventCallback("equip", inst._onownerequip, inst._owner)
		inst._owner = nil
	end
end

local function starttrackingowner(inst, owner)
	if owner ~= inst._owner then
		stoptrackingowner(inst)
		if owner ~= nil and owner.components.inventory ~= nil then
			inst._owner = owner
			inst:ListenForEvent("equip", inst._onownerequip, owner)
		end
	end
end

local function turnon(inst)
	if not inst.components.fueled:IsEmpty() then
		inst.components.fueled:StartConsuming()

		local owner = inst.components.inventoryitem.owner

		if inst._light == nil then
			inst._light = SpawnPrefab("lanternlight")
			inst._light._lantern = inst
			inst:ListenForEvent("onremove", onremovelight, inst._light)
			fuelupdate(inst)
			PlayTurnOnSound(inst)
		end
		inst._light.entity:SetParent((owner or inst).entity)

		inst.components.floater:UpdateAnimations("idle_on_water", "idle_on")

		if owner ~= nil and inst.components.equippable:IsEquipped() then
			owner.AnimState:OverrideSymbol("swap_object", "swap_bottlle_lantern", "swap_lantern_on")
			owner.AnimState:Show("LANTERN_OVERLAY")
		end

		inst.components.machine.ison = true
		inst.components.inventoryitem:ChangeImageName("bottlelantern")
		inst:PushEvent("lantern_on")
	end
end

local function turnoff(inst)
	stoptrackingowner(inst)

	inst.components.fueled:StopConsuming()

	if inst._light ~= nil then
		inst._light:Remove()
		PlayTurnOffSound(inst)
	end

	inst.components.floater:UpdateAnimations("idle_water", "idle_off")

	if inst.components.equippable:IsEquipped() then
		local owner = inst.components.inventoryitem.owner
		owner.AnimState:OverrideSymbol("swap_object", "swap_bottlle_lantern", "swap_lantern_off")
		owner.AnimState:Hide("LANTERN_OVERLAY")
	end

	inst.components.machine.ison = false
	inst.components.inventoryitem:ChangeImageName("bottlelantern_off")
	inst:PushEvent("lantern_off")
end

local function OnRemove(inst)
	if inst._light ~= nil then
		inst._light:Remove()
	end
	if inst._soundtask ~= nil then
		inst._soundtask:Cancel()
	end
end

local function ondropped(inst)
	turnoff(inst)
	turnon(inst)
end

local function onequip(inst, owner)
    if owner.sg:HasStateTag("rowing") then return end
	owner.AnimState:OverrideSymbol("swap_object", "swap_bottlle_lantern", "swap_lantern_off")
	owner.AnimState:OverrideSymbol("lantern_overlay", "swap_bottlle_lantern", "lantern_overlay")

	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")

	if inst.components.fueled:IsEmpty() then
		owner.AnimState:OverrideSymbol("swap_object", "swap_bottlle_lantern", "swap_lantern_off")
		owner.AnimState:Hide("LANTERN_OVERLAY")
	else
		owner.AnimState:OverrideSymbol("swap_object", "swap_bottlle_lantern", "swap_lantern_on")
		owner.AnimState:Show("LANTERN_OVERLAY")
		turnon(inst)
	end
end

local function onunequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
	owner.AnimState:ClearOverrideSymbol("lantern_overlay")
	owner.AnimState:Hide("LANTERN_OVERLAY")

	if inst.components.machine.ison then
		starttrackingowner(inst, owner)
	end
end

local function nofuel(inst)
	if inst.components.equippable:IsEquipped() and inst.components.inventoryitem.owner ~= nil then
		local data =
		{
			prefab = inst.prefab,
			equipslot = inst.components.equippable.equipslot,
		}
		turnoff(inst)
		inst.components.inventoryitem.owner:PushEvent("torchranout", data)
	else
		turnoff(inst)
	end
end

local function ontakefuel(inst)
	if inst.components.equippable:IsEquipped() then
		turnon(inst)
	end
end

--------------------------------------------------------------------------

local function OnLightWake(inst)
	if not inst.SoundEmitter:PlayingSound("loop") then
		inst.SoundEmitter:PlaySound("ia/common/bottlelantern_lp", "loop")
	end
end

local function OnLightSleep(inst)
	inst.SoundEmitter:KillSound("loop")
end

--------------------------------------------------------------------------

local function lanternlightfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:AddTag("FX")

	inst.Light:SetColour(0 / 255, 180 / 255, 255 / 255)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.persists = false

	inst.OnEntityWake = OnLightWake
	inst.OnEntitySleep = OnLightSleep

	return inst
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("lantern_bottle")
	inst.AnimState:SetBuild("lantern_bottle")
	inst.AnimState:PlayAnimation("idle_off")

	inst:AddTag("light")

	MakeInventoryFloatable(inst)
	inst.components.floater:UpdateAnimations("idle_water", "idle_off")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")

	MakeInvItemIA(inst)

	inst.components.inventoryitem:SetOnDroppedFn(ondropped)
	inst.components.inventoryitem:SetOnPutInInventoryFn(turnoff)

	inst:AddComponent("equippable")

	inst:AddComponent("fueled")

	inst:AddComponent("machine")
	inst.components.machine.turnonfn = turnon
	inst.components.machine.turnofffn = turnoff
	inst.components.machine.cooldowntime = 0

	inst.components.fueled.fueltype = FUELTYPE.CAVE
	inst.components.fueled:InitializeFuelLevel(TUNING.BOTTLE_LANTERN_LIGHTTIME)
	inst.components.fueled:SetDepletedFn(nofuel)
	inst.components.fueled:SetUpdateFn(fuelupdate)
	inst.components.fueled:SetTakeFuelFn(ontakefuel)
	inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
	inst.components.fueled.accepting = true

	inst._light = nil

	MakeHauntableLaunch(inst)

	inst.components.equippable:SetOnEquip(onequip)
	inst.components.equippable:SetOnUnequip(onunequip)

	inst.OnRemoveEntity = OnRemove

	inst._onownerequip = function(owner, data)
		if data.item ~= inst and
			(   data.eslot == EQUIPSLOTS.HANDS or
				(data.eslot == EQUIPSLOTS.BODY and data.item:HasTag("heavy"))
			) then
			turnoff(inst)
		end
	end

    inst:ListenForEvent("startrowing", function(inst, data)
        turnoff(inst)
    end)  

    inst:ListenForEvent("stoprowing", function(inst, data)
        turnon(inst)
    end)

	return inst
end

return Prefab("bottlelantern", fn, assets, prefabs),
	Prefab("bottlelanternlight", lanternlightfn)
