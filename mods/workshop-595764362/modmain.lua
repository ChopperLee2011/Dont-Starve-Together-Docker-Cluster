if GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated() then
	local ONEDIR_CONNECTIONS = {}
	local BIDIR_CONNECTIONS = {}
	local DELETE_UNUSED = GetModConfigData("DeleteUnused")
	local SYNC_FROM_MASTER = GetModConfigData("SyncFromMaster")
	
	if GLOBAL.TheShard:IsMaster() or not SYNC_FROM_MASTER then
		ONEDIR_CONNECTIONS = GetModConfigData("OneWayConnections")
		BIDIR_CONNECTIONS = GetModConfigData("Connections")
	end
	
	local spawnedPortals = {}
	local thisShardPortalIds = {}
	
	local function RegisterId(prefab)
		table.insert(thisShardPortalIds, prefab.components.worldmigrator.id)
		table.sort(thisShardPortalIds)
	end
	
	local function Connect(prefab)
		local shardId = GLOBAL.TheShard:GetShardId()
		local portalId = prefab.components.worldmigrator.id
		
		prefab.components.worldmigrator.linkedWorld = -1
		prefab.components.worldmigrator.auto = false
		
		local nextFreePortal = {}
		for from, toTable in pairs(BIDIR_CONNECTIONS) do
			nextFreePortal[from] = nextFreePortal[from] or 1
			
			for id, to in pairs(toTable) do
				nextFreePortal[to] = nextFreePortal[to] or 1
				
				local fromPortal = nextFreePortal[from]
				local toPortal = nextFreePortal[to]
				
				if ((from == shardId) or (to == shardId)) then
					if (thisShardPortalIds[nextFreePortal[shardId]] == portalId) then
						--print("Two way "..from.."->"..to)
						prefab.components.worldmigrator.linkedWorld = (from == shardId) and to or from
						prefab.components.worldmigrator.receivedPortal = (from == shardId) and toPortal or fromPortal
						prefab.components.worldmigrator:SetEnabled(true)

						return
					end
				end
				
				nextFreePortal[from] = nextFreePortal[from] + 1
				nextFreePortal[to] = nextFreePortal[to] + 1
			end
		end
				
		for from, toTable in pairs(ONEDIR_CONNECTIONS) do
			nextFreePortal[from] = nextFreePortal[from] or 1
			
			for id, to in pairs(toTable) do
				nextFreePortal[to] = nextFreePortal[to] or 1
				
				local fromPortal = nextFreePortal[from]
				local toPortal = nextFreePortal[to]
				
				if (from == shardId) then
					if (thisShardPortalIds[nextFreePortal[shardId]] == portalId) then
						--print("One way "..from.."->"..to)
						-- allow travel from->to
						prefab.components.worldmigrator.linkedWorld = to
						prefab.components.worldmigrator.receivedPortal = toPortal
						prefab.components.worldmigrator:SetEnabled(true)
						
						return
					end
				elseif (to == shardId) then
					if (thisShardPortalIds[nextFreePortal[shardId]] == portalId) then
						--print("Denied One way "..from.."->"..to)
						-- deny travel to->from
						prefab.components.worldmigrator:SetEnabled(false)
						
						return
					end
				end
				
				nextFreePortal[from] = nextFreePortal[from] + 1
				nextFreePortal[to] = nextFreePortal[to] + 1
			end
		end
		
		if DELETE_UNUSED then
			print("Removing portal "..portalId)
			prefab:Remove()
		else
			prefab.components.worldmigrator:SetEnabled(false)
		end
	end
	
	local function SyncDone(inst, data)
		ONEDIR_CONNECTIONS = data["one"]
		BIDIR_CONNECTIONS = data["bi"]
	
		-- update all worldmigrators
		for _, entity in pairs(spawnedPortals) do
			entity:DoTaskInTime(1, RegisterId)
			entity:DoTaskInTime(2, Connect)
		end
		
		-- init all new prefabs
		AddPrefabPostInitAny(function (prefab)
			if prefab and prefab.components and prefab.components.worldmigrator then
				prefab:DoTaskInTime(1, RegisterId)
				prefab:DoTaskInTime(2, Connect)
			end
		end)
	end
	
	AddPrefabPostInitAny(function (prefab)
		if prefab and prefab.components and prefab.components.worldmigrator then
			if GLOBAL.TheShard:IsMaster() or not SYNC_FROM_MASTER then
				prefab:DoTaskInTime(1, RegisterId)
				prefab:DoTaskInTime(2, Connect)
			else
				table.insert(spawnedPortals, prefab)
			end
		end
	end)
	
	if SYNC_FROM_MASTER then
		AddPrefabPostInit("shard_network", function(prefab)
			prefab:AddComponent("sync")
			
			if GLOBAL.TheShard:IsMaster() then
				prefab:DoTaskInTime(1, function()
					prefab.components.sync:SyncConnections(ONEDIR_CONNECTIONS, BIDIR_CONNECTIONS)
				end)
			else
				prefab:ListenForEvent("Shard_Configuration_Mod.AfterConnectionDataChanged", SyncDone)
			end
		end)
	end
end