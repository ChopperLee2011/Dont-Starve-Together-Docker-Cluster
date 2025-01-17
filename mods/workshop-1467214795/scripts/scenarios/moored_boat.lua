
local function PlaceBoatOnShore(inst, prefab)
	local world = TheWorld

	local findtile = function(checkFn, x, y, radius)
		for i = -radius, radius, 1 do
			if checkFn(world.Map:GetTile(x - radius, y + i)) then
				return x - radius, y + i
			end
			if checkFn(world.Map:GetTile(x + radius, y + i)) then
				return x + radius, y + i
			end
		end
		for i = -(radius - 1), radius - 1, 1 do
			if checkFn(world.Map:GetTile(x + i, y - radius)) then
				return x + i, y - radius
			end
			if checkFn(world.Map:GetTile(x + i, y + radius)) then
				return x + i, y + radius
			end
		end
		return nil, nil
	end

	local findtileradius = function(checkFn, px, py, pz, max_radius)
		local x, y = world.Map:GetTileXYAtPoint(px, py, pz)

		for i=1, max_radius, 1 do
			local bx, by = findtile(checkFn, x, y, i)
			if bx and by then
				return bx, by
			end
		end
		return nil, nil
	end

	local boat
	local px, py, pz = inst.Transform:GetWorldPosition()
	local shorex, shorey = findtileradius(function(tile) return tile == GROUND.BEACH end, px, py, pz, 50)
	if shorex and shorey then
		boat = SpawnPrefab(prefab)
		if boat then
			local width, height = world.Map:GetSize()
			local tx = (shorex - width/2.0)*TILE_SCALE
			local tz = (shorey - height/2.0)*TILE_SCALE

			local shalx, shaly = findtileradius(function(tile) return tile == GROUND.OCEAN_SHALLOW end, tx, 0, tz, 1)
			--local landx, landy = findtileradius(function(tile) return world.Map:IsLand(tile) end, tx, 0, tz, 1)
			if shalx and shaly then
				--offset slightly
				local tx2 = (shalx - width/2.0)*TILE_SCALE
				local tz2 = (shaly - height/2.0)*TILE_SCALE
				--local tx2 = (landx - width/2.0)*TILE_SCALE
				--local tz2 = (landy - height/2.0)*TILE_SCALE
				tx = Lerp(tx, tx2, 0.5) --tx = tx + 0.5 * (tx2 - tx)
				tz = Lerp(tz, tz2, 0.5) --tz = tz + 0.5 * (tz2 - tz)
			end

			boat.Transform:SetPosition(tx, 0, tz)
		end
	end

	return boat
end

local function OnCreate(inst, scenariorunner)
	if inst == nil then
		return
	end

	local boat = PlaceBoatOnShore(inst, "boat_row")
	if boat then
		local pt = inst:GetPosition()
		--[[local sail = SpawnPrefab("sail_palmleaf")
		if sail then
			boat.components.boatequip:EquipSail(sail)
		end]]
		local lantern = SpawnPrefab("boat_lantern")
		if lantern then
			lantern.Transform:SetPosition(pt.x + .5, 0, pt.z - 1)
			-- boat.components.boatequip:EquipLamp(lantern)
			-- lantern.components.equippable:ToggleOff() --TODO
		end
	else
		print("Unable to place Boat!")
	end

	inst:Remove()
end

return
{
	OnCreate = OnCreate
}