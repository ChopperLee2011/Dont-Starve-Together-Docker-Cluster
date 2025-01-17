-- If we ever have more than 1 instance of this component, we probably should move these variables
local windfx_rate = 0
local windfx_per_sec = 16

local WindVisuals = Class(function(self, inst)
	self.inst = inst

	inst:StartUpdatingComponent(self)
end)

local function SpawnWindSwirl(x, y, z, angle)
	local swirl = SpawnPrefab("windswirl")
	swirl.Transform:SetPosition(x, y, z)
	swirl.Transform:SetRotation(angle + 180)
	--swirl.Physics:SetMotorVel(speed, 0, 0)
end

function WindVisuals:OnUpdate(dt)
	if TheWorld.state.hurricane and TheWorld.state.gustspeed > .1 and IsInIAClimate(self.inst) then
		windfx_rate = windfx_rate + windfx_per_sec * dt
		local px, py, pz = self.inst.Transform:GetWorldPosition()
		--print(string.format("wind %f, %4.2f, %4.f", sm:GetHurricaneWindSpeed(), self.windfx_rate, self:GetWindAngle()))
		while windfx_rate > 1.0 do
			local dx, dz = 16 * UnitRand(), 16 * UnitRand()
			local x, y, z = px + dx, py, pz + dz
			local angle = TheWorld.state.gustangle

			SpawnWindSwirl(x, 0, z, angle)
			windfx_rate = windfx_rate - 1.0
		end
	end
	
end

function WindVisuals:SetRate(rate)
	windfx_per_sec = rate or 16
end

return WindVisuals