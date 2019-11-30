-- This file loads all static layouts and contains all non-static layouts
local IAENV = env

GLOBAL.setfenv(1, GLOBAL)


local StaticLayout = require("map/static_layout")
local AllLayouts = require("map/layouts").Layouts
require("constants")

local ground_types = {
	--Translates tile type index from constants.lua into tiled tileset. 
	--Order they appear here is the order they will be used in tiled.
	GROUND.IMPASSABLE, GROUND.ROAD, GROUND.ROCKY, GROUND.DIRT, 
	GROUND.SAVANNA, GROUND.GRASS, GROUND.FOREST, GROUND.MARSH, 
	GROUND.WOODFLOOR, GROUND.CARPET, GROUND.CHECKER,
	GROUND.CAVE, GROUND.FUNGUS, GROUND.SINKHOLE, --12, 13, 14
	GROUND.WALL_ROCKY, GROUND.WALL_DIRT, GROUND.WALL_MARSH, 
	GROUND.WALL_CAVE, GROUND.WALL_FUNGUS, GROUND.WALL_SINKHOLE, 
	GROUND.UNDERROCK, GROUND.MUD, GROUND.WALL_MUD, GROUND.WALL_WOOD,
	GROUND.BRICK, GROUND.BRICK_GLOW, GROUND.TILES, GROUND.TILES_GLOW,  --25, 26, 27, 28
	GROUND.TRIM, GROUND.TRIM_GLOW, GROUND.WALL_HUNESTONE, GROUND.WALL_HUNESTONE_GLOW,
	GROUND.WALL_STONEEYE, GROUND.WALL_STONEEYE_GLOW, GROUND.FUNGUSRED, GROUND.FUNGUSGREEN,
	GROUND.BEACH, GROUND.JUNGLE, GROUND.SWAMP, --37, 38, 39
	GROUND.OCEAN_SHALLOW, GROUND.OCEAN_MEDIUM, GROUND.OCEAN_DEEP,
	GROUND.OCEAN_CORAL, GROUND.MANGROVE, GROUND.MAGMAFIELD, GROUND.TIDALMARSH, GROUND.MEADOW,
	GROUND.VOLCANO, GROUND.VOLCANO_LAVA, GROUND.ASH, GROUND.VOLCANO_ROCK, --48, 49, 50, 51
	GROUND.OCEAN_SHIPGRAVEYARD, GROUND.RIVER
}

--Edit existing Oasis layout to use the more fitting palmtree
if AllLayouts["Oasis"] and AllLayouts["Oasis"].layout and AllLayouts["Oasis"].layout.deciduoustree then
	AllLayouts["Oasis"].layout.palmtree = AllLayouts["Oasis"].layout.deciduoustree
	AllLayouts["Oasis"].layout.deciduoustree = nil
end


AllLayouts["IA_Start"] = StaticLayout.Get("map/static_layouts/ia_start", {
	start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.CENTER,
	defs={
		welcomitem = IsSpecialEventActive(SPECIAL_EVENTS.HALLOWED_NIGHTS) and {"pumpkin_lantern"} or {"crate"},
	}
})
AllLayouts["IA_Start"].ground_types = ground_types
AllLayouts["VolcanoStart"] = StaticLayout.Get("map/static_layouts/volcano_start", {
	start_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.CENTER,
	disable_transform = true,
})
AllLayouts["VolcanoStart"].ground_types = ground_types
AllLayouts["Casino"] = StaticLayout.Get("map/static_layouts/casino", {border = 1,
	start_mask = PLACE_MASK.NORMAL,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.CENTER,
	restrict_to_valid_land = true,
})
AllLayouts["Casino"].ground_types = ground_types
-- AllLayouts["BeachRaftHome"] = StaticLayout.Get("map/static_layouts/beach_raft_home", {start_mask = PLACE_MASK.IGNORE_WATER, fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_WATER}),
AllLayouts["Xspot"] = StaticLayout.Get("map/static_layouts/x_spot")
AllLayouts["Xspot"].ground_types = ground_types
AllLayouts["SharkHome"] = StaticLayout.Get("map/static_layouts/sharkhome", {
	restrict_to_valid_land = true,
})
AllLayouts["SharkHome"].ground_types = ground_types
AllLayouts["DoydoyGirl"] = StaticLayout.Get("map/static_layouts/doydoy1", {fill_mask = PLACE_MASK.IGNORE_WATER})
AllLayouts["DoydoyGirl"].ground_types = ground_types
AllLayouts["DoydoyBoy"] = StaticLayout.Get("map/static_layouts/doydoy2", {fill_mask = PLACE_MASK.IGNORE_WATER})
AllLayouts["DoydoyBoy"].ground_types = ground_types
AllLayouts["VolcanoAltar"] = StaticLayout.Get("map/static_layouts/volcano_altar")
AllLayouts["VolcanoAltar"].ground_types = ground_types
AllLayouts["BerryBushBunch"] = StaticLayout.Get("map/static_layouts/berrybushbunch")
AllLayouts["BerryBushBunch"].ground_types = ground_types
-- AllLayouts["CoffeeBushBunch"] = StaticLayout.Get("map/static_layouts/coffeebushbunch")
-- AllLayouts["SWPortal"] = StaticLayout.Get("map/static_layouts/sw_portal")
AllLayouts["JungleOasis"] = StaticLayout.Get("map/static_layouts/oasis2", {
	restrict_to_valid_land = true,
	layout_position = LAYOUT_POSITION.CENTER,
})
AllLayouts["JungleOasis"].ground_types = ground_types
AllLayouts["BuriedTreasureLayout"] = 
{
	type = LAYOUT.STATIC,
	ground = {
			{0, 0,},
			{0, 0,},
		},
	layout = {
			buriedtreasure = { {x=0,y=0} },
		},
	scale = 1
}
AllLayouts["TreasureHunterMap"] = StaticLayout.Get("map/static_layouts/small_boon", {
	areas = {
		item_area = {"messagebottle", "piratehat"},
		resource_area = {"dubloon"},
		},
})
AllLayouts["TreasureHunterBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
	areas = {
		item_area = {"messagebottle", "messagebottleempty", "strawhat"},
		resource_area = {},
		},
})
-- AllLayouts["PalmTreeIsland"] = StaticLayout.Get("map/static_layouts/islands/palmtreeisland", {
	-- disable_transform = true,
	-- areas = {
		-- item_area = {"palmtree", "skeleton", "seashell_beached"}
	-- }
-- })
-- AllLayouts["ShipwreckedEntrance"] = 
-- {
	-- type = LAYOUT.STATIC,
	-- layout = {
			-- shipwrecked_entrance = { {x=0,y=0} },
		-- },
	-- scale = 1,
-- }
-- AllLayouts["ShipwreckedExit"] = StaticLayout.Get("map/static_layouts/islands/palmtreeisland"),
-- {
-- 	type = LAYOUT.STATIC,
-- 	layout = {
-- 			shipwrecked_exit = { {x=0,y=0} },
-- 		},
-- 	scale = 1,
-- }
AllLayouts["LivingJungleTree"] = StaticLayout.Get("map/static_layouts/livingjungletree")
AllLayouts["ResurrectionStoneSw"] = StaticLayout.Get("map/static_layouts/resurrectionstone_sw", {border=1})
AllLayouts["RockSkull"] = StaticLayout.Get("map/static_layouts/skull_isle2", {
	areas = {
		area_1 = function() return PickSomeWithDups(math.random(5,8), {"rocks", "flint"}) end,
		area_2 = function() return PickSomeWithDups(math.random(5,8), {"rocks", "flint"}) end,
		area_3 = function() return PickSomeWithDups(math.random(5,8), {"rocks", "flint"}) end,
		area_4 = function() return PickSomeWithDups(math.random(5,8), {"rocks", "flint"}) end,
		area_5 = function() return PickSomeWithDups(math.random(5,8), {"rocks", "flint"}) end,
		area_6 = function() return PickSomeWithDups(math.random(5,8), {"rocks", "flint"}) end,
		area_7 = function() return PickSomeWithDups(math.random(4,7), {"rocks", "flint"}) end,
		area_8 = function() return PickSomeWithDups(math.random(5,8), {"rocks", "flint"}) end,
		area_9 = function() return PickSomeWithDups(math.random(4,7), {"rocks", "flint", "goldnugget"}) end,
		area_10 = function() return PickSomeWithDups(math.random(5,8), {"rocks", "flint", "goldnugget"}) end,
	},
	fill_mask = PLACE_MASK.IGNORE_WATER
})
AllLayouts["RockSkull"].ground_types = ground_types
AllLayouts["TidalpoolMedium"] = 
{
	type = LAYOUT.STATIC,
	ground = {
			{0, 0,},
			{0, 0,},
		},
	layout = {
			tidalpool = { {x=0,y=0,properties={data={size=2}}} },
		},
	scale = 1,
}
AllLayouts["TidalpoolLarge"] = 
{
	type = LAYOUT.STATIC,
	ground = {
			{0, 0,},
			{0, 0,},
		},
	layout = {
			tidalpool = { {x=0,y=0,properties={data={size=3}}} },
		},
	scale = 1,
}
AllLayouts["ObsidianWorkbench"] = StaticLayout.Get("map/static_layouts/volcano_workbench")
AllLayouts["ObsidianWorkbench"].ground_types = ground_types
AllLayouts["Volcano"] =
{
	type = LAYOUT.STATIC,
	ground = {
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		},
	layout = {
			volcano = { {x=0,y=0} },
		},
	scale = 1,
}
-- AllLayouts["WilburUnlock"] = StaticLayout.Get("map/static_layouts/wilbur_unlock", {water = true}),
-- AllLayouts["WoodlegsUnlock"] = StaticLayout.Get("map/static_layouts/woodlegs_unlock"),
AllLayouts["Wreck"] = StaticLayout.Get("map/static_layouts/wreck", {
	water = true,
	areas = {
			ship_area = {"shipwreck"},
			mast_area = function() if math.random() < 0.75 then return {"shipwreck"} else return {} end end,
			debris_area = PickSomeWithDups(math.random(1, 4), {"boards", "rope", "fabric", "messagebottleempty"})
	},
})
AllLayouts["OctopusKing"] = 
{
	type = LAYOUT.STATIC,
	water = true,
	ground = {
			{0, 0,},
			{0, 0,},
		},
	layout = {
			octopusking = { {x=0,y=0} },
		},
	scale = 1,
}
AllLayouts["ShipgraveLuggage"] = 
{
	type = LAYOUT.STATIC,
	water = true,
	ground = {
			{0},
		},
	layout = {
			luggagechest = { {x=0,y=0,properties={scenario="chest_shipgrave"}} },
		},
	scale = 1,
}


--TODO hook these up
AllLayouts["SeaFarerBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
	areas = {
		item_area = function() return PickSomeWithProbs({telescope=0.5,armor_lifejacket=1.0,captainhat=0.48}) end,
		resource_area = {} --function() return PickSomeWithDups(3, {"seaweed_planted"}) end,
		},
})

AllLayouts["JungleHackerBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
	areas = {
		item_area = function() return PickSomeWithProbs({machete=0.4}) end,
		resource_area = {"bamboo", "bamboo", "bamboo", "vine", "vine", "snakeskin"},
		},
})

AllLayouts["DrunkenPirateBoon"] = StaticLayout.Get("map/static_layouts/small_boon", {
	areas = {
		item_area = {"piratehat"},
		resource_area = function() return PickSomeWithDups(5, {"messagebottleempty"}) end,
		},
})

AllLayouts["AbandonedRaftBoon"] = StaticLayout.Get("map/static_layouts/water_boon", {
	water = true,
	areas = {
		item_area = {"boat_raft"},
		resource_area = {"spear_launcher"},
	}
})

AllLayouts["AbandonedSailBoon"] = StaticLayout.Get("map/static_layouts/water_boon", {
	water = true,
	areas = {
		item_area = {"boat_row"},
		resource_area = function() return nil end,
		},
	initfn = function(layout)
		for i = 1, #layout.item_area, 1 do
			layout.item_area[i].properties.scenario = "derelict_sailboat"
		end
	end
})
AllLayouts["Airstrike"] =
{
	type = LAYOUT.CIRCLE_EDGE,
	width = 8,
	height = 8,
	start_mask = PLACE_MASK.NORMAL,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.CENTER,
	count = {
			obsidian = 6,
		},
	layout = {
			volcanostaff = { {x=0,y=0,properties={["scenario"] = "staff_erruption"} } },
		},
	ground = {
			{0},
		},

	scale = 2,
}
AllLayouts["AirPollution"] =
{
	type = LAYOUT.CIRCLE_EDGE,
	width = 8,
	height = 8,
	start_mask = PLACE_MASK.NORMAL,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.CENTER,
	count = {
			poisonhole = 6,
		},
	layout = {
			item_area = {{x=0,y=0,width=0.4,height=0.4}}
		},
	ground = {
			{0},
		},
	areas = {
			item_area = {"spear_poison", "venomgland", "venomgland", "tentacle", "tentacle", "tentacle"}
		},

	scale = 3,
}
AllLayouts["PoisonVines"] = 
{
	type = LAYOUT.STATIC,
	width = 8,
	height = 8,
	start_mask = PLACE_MASK.NORMAL,
	fill_mask = PLACE_MASK.IGNORE_IMPASSABLE_BARREN_RESERVED,
	layout_position = LAYOUT_POSITION.CENTER,
	ground = {
			{0},
		},
	layout = {
			bush_vine =
			{
				{x=0.866,y=0.5,properties={["scenario"] = "vine_hideout"} },
				{x=0.866,y=-0.5,properties={["scenario"] = "vine_hideout"} },
				{x=0,y=-1,properties={["scenario"] = "vine_hideout"} },
				{x=-0.866,y=-0.5,properties={["scenario"] = "vine_hideout"} },
				{x=-0.866,y=0.5,properties={["scenario"] = "vine_hideout"} },
				{x=0,y=1,properties={["scenario"] = "vine_hideout"} }
			},
			item_area = {{x=0,y=0,width=0.4,height=0.4,properties={["scenario"] = "snake_ambush"} }}
		},
	areas = {
			item_area = {"venomgland", "venomgland", "venomgland"}
	},

	scale = 2
}
AllLayouts["FeedingFrenzy"] = 
{
	type = LAYOUT.STATIC,
	water = true,
	ground = {
			{0},
		},
	layout = {
			boat_cargo = { {x=0,y=0,properties={["scenario"] = "sharx_ambush"}} },
		},
	scale = 1,
}
--TODO hook the above ones up


