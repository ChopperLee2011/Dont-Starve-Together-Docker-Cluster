name = "Shard Configuration Mod"
description = "Allows admin to set up shard connections."
author = "Nuke"
version = "2.0.3"
forumthread = "http://forums.kleientertainment.com/files/file/1413-shard-configuration-mod/"

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

dst_compatible = true
reign_of_giants_compatible = true

server_only_mod = true
all_clients_require_mod = false
client_only_mod = false

configuration_options =
{
	{
		name = "DeleteUnused",
		description = "Mod will delete unused portals instead just plugging them.",
		default = false
	},
	{
		name = "SyncFromMaster",
		description = "Slave shards will get connection lists from master shard. This setting have to be the same for every shard.",
		default = true
	},
	{
		name = "Connections",
		description = "List of bidirectional connections between shards.",
		default = { }
	},
	{
		name = "OneWayConnections",
		description = "List of unidirectional connections between shards.",
		default = { }
	}
	
	-- Sample override (shard id needs to be string):
	--["workshop-595764362"] = {
	--    enabled = true,
	--    configuration_options = {
	--	["DeleteUnused"] = true,
	--	["SyncFromMaster"] = false,
	--        ["Connections"] = {
	--            ["1"] = { "11", "11", "12" },-- two way connection between 1-11 shards (to times) and 1-12 shards (one time)
	--            ["11"] = { "12" },-- two way connection between 11-12 shards (one time)
	--        },
	--        ["OneWayConnections"] = {
	--            ["1"] = { "13", "13" }-- one way connection from shard 1 to shard 13 (two time)
	--        }
	--    }
	--},
}


