local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

----------------------------------------------------------------------------------------

local function CheckPrefabValidity(prefabs)
    if type(prefabs) == "string" then
        PrefabExists(prefabs)
    elseif type(prefabs) == "table" then
        for k, v in pairs(prefabs) do
            if not PrefabExists(v) then return false end
        end
        return true
    else
        return false
    end
end

local _SpawnLootPrefab
local function SpawnLootPrefab(self, loot, pt, ...)
    if self.inst.prefab == "spiderqueen" and loot == "spider_warrior" and IsInIAClimate(self.inst) then
        loot = "tropical_spider_warrior"
    end
    local item = _SpawnLootPrefab(self, loot, pt, ...)

	--This should never happen, but failsafe regardless.
	if not item then return end

    if self.inst.components.poisonable and self.inst.components.poisonable:IsPoisoned() and item.components.perishable then
        item.components.perishable:ReducePercent(TUNING.POISON_PERISH_PENALTY)
    end
	
	if item.components.visualvariant then
		item.components.visualvariant:CopyOf(self.inst)
	end
	
	return item
end

local function GetBaseName(prefab)
  local cookedAfter = prefab.."_cooked"
  local cookedBefore = "cooked"..prefab
  if PrefabExists(cookedAfter) then
    return cookedAfter
  elseif PrefabExists(cookedBefore) then
    return cookedBefore
  else
    return "ash"
  end
end

local function CheckBurnable(self, prefabs)
  -- check burnable
  if not self.inst.components.fueled and self.inst.components.burnable and self.inst.components.burnable:IsBurning() then
    if type(prefabs) == "string" then
      return GetBaseName(prefabs)
    elseif type(prefabs) == "table" then
      for k,v in pairs(prefabs) do
        prefabs[k] = GetBaseName(v)
      end
    end
  end	
  return prefabs
end

local _DropLoot
local function DropLoot(self, pt, force_loot)
  if (type(force_loot) == "string" or type(force_loot) == "table") and CheckPrefabValidity(force_loot) then
    local prefabs = force_loot
    prefabs = self:CheckBurnable(prefabs)

    if type(prefabs) == "string" then
      self:SpawnLootPrefab(prefabs, pt)
    else
      for k,v in pairs(prefabs) do
        self:SpawnLootPrefab(v, pt)
      end
    end
  else
    _DropLoot(self, pt)
  end
end

local function ExplodeLoot(self, pt, speed, loots)
  local prefabs = loots
  if prefabs == nil then
    prefabs = self:GenerateLoot()
  end
  self:CheckBurnable(prefabs)
  self.speed = speed or 1
  for k,v in pairs(prefabs) do
    local newprefab = self:SpawnLootPrefab(v, pt)
    local vx, vy, vz = newprefab.Physics:GetVelocity()
    newprefab.Physics:SetVel(vx, 35, vz)
  end

  self.speed = 1
end

----------------------------------------------------------------------------------------
--Try to initialise all functions locally outside of the post-init so they exist in RAM only once
----------------------------------------------------------------------------------------

IAENV.AddComponentPostInit("lootdropper", function(cmp)


_SpawnLootPrefab = cmp.SpawnLootPrefab
cmp.SpawnLootPrefab = SpawnLootPrefab
_DropLoot = cmp.DropLoot
cmp.DropLoot = DropLoot
cmp.ExplodeLoot = ExplodeLoot
cmp.CheckBurnable = CheckBurnable


end)
