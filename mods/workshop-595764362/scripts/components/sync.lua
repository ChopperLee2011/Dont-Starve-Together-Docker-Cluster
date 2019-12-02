local ShardModSync = Class(function(self, inst)

	self._inst = inst
	self.connectionData = net_string(inst.GUID, "Shard_Configuration_Mod.ConnectionData", "OnConnectionDataChanged")
	
	local function OnConnectionDataChanged()
		print("Shard Configuration Mod: Synchronizing connection data from master")
		
		if self.connectionData:value() then
			local oneDir = {}
			local biDir = {}
			
			local allData = string.split(self.connectionData:value(), ";")
			
			if #allData == 2 then
				for _, line in pairs(string.split(allData[1], "\n")) do
					local lineArray = string.split(line, "=>")
					
					if #lineArray == 2 then
						oneDir[lineArray[1]] = string.split(lineArray[2], ",")
					end
				end
				
				for _, line in pairs(string.split(allData[2], "\n")) do
					local lineArray = string.split(line, "=>")
					
					if #lineArray == 2 then
						biDir[lineArray[1]] = string.split(lineArray[2], ",")
					end
				end
				
				-- reconnect all shards
				self._inst:PushEvent("Shard_Configuration_Mod.AfterConnectionDataChanged", {
					one = oneDir,
					bi = biDir,
				})
				print("Synchronization succeded")
			else
				print("Synchronization failed: != 2\n"..self.connectionData:value())
			end
		else
			print("Synchronization failed: nil")
		end
	end
	
	if not TheWorld.ismastershard then
		inst:ListenForEvent("OnConnectionDataChanged", OnConnectionDataChanged)
	end
end)

function ShardModSync:SyncConnections(oneDir, biDir)
	local data = "\n"
	
	for i, toTable in pairs(oneDir) do
		data = data..i.."=>"..table.concat(toTable, ",").."\n"
	end
	
	data = data..";"
	
	for i, toTable in pairs(biDir) do
		data = data..i.."=>"..table.concat(toTable, ",").."\n"
	end
	
	data = data.."\n"
	
	print("Shard Configuration Mod: Synchronizing connection data to slaves")
	
	self.connectionData:set(data)
end

return ShardModSync