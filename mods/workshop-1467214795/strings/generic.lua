-- This speech is for Wilson, also mod characters if they don't have quotes already (hence "generic")
return {

ACTIONFAIL =
{
	REPAIRBOAT = 
	{
		GENERIC = "She's floating just fine right now.",
	},
	EMBARK = 
	{
		INUSE = "The ship has left port without me!",
	},
	INSPECTBOAT = 
	{
		INUSE = GLOBAL.STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.STORE.INUSE
	},
},

ANNOUNCE_MAGIC_FAIL = "It won't work here.",

ANNOUNCE_SHARX = "I'm going to need a bigger boat...",

ANNOUNCE_TREASURE = "It's a map! And it marks a location!",
ANNOUNCE_MORETREASURE = "Seriously? Another one!?",
ANNOUNCE_OTHER_WORLD_TREASURE = "This map doesn't correlate to my current surroundings.",
ANNOUNCE_OTHER_WORLD_PLANT = "I don't think this soil has the proper nutrients.",

ANNOUNCE_MESSAGEBOTTLE =
{
	"The message is faded. I can't read it.",
},
ANNOUNCE_VOLCANO_ERUPT = "That can't be good.",
ANNOUNCE_MAPWRAP_WARN = "Here be monsters.",
ANNOUNCE_MAPWRAP_LOSECONTROL = "It would seem my future is foggy.",
ANNOUNCE_MAPWRAP_RETURN = "I think I felt something brush against my leg...",
ANNOUNCE_CRAB_ESCAPE = "I could've sworn it was right there...",
ANNOUNCE_TRAWL_FULL = "My net filled up!",
ANNOUNCE_BOAT_DAMAGED = "I think I sprung a leak.",
ANNOUNCE_BOAT_SINKING = "I seem to be sinking.",
ANNOUNCE_BOAT_SINKING_IMMINENT = "I need to get to land!",
ANNOUNCE_WAVE_BOOST = "Weeeee!",

ANNOUNCE_WHALE_HUNT_BEAST_NEARBY = "Follow those bubbles!",
ANNOUNCE_WHALE_HUNT_LOST_TRAIL = "I wonder where it went...",
ANNOUNCE_WHALE_HUNT_LOST_TRAIL_SPRING = "The water is too rough!",


DESCRIBE = {
	
	--Coming in from Shipwrecked Characters (SWC) -Cheese
	-- PORTABLECOOKPOT_ITEM = "Now we're cookin'!",
	CHEFPACK = "His bag of chef's tricks!",
	-- PORTABLECOOKPOT = 
	-- {
        -- COOKING_LONG = "I'm no chef, but I think that's going to take awhile.",
        -- COOKING_SHORT = "It's almost done!",
        -- DONE = "Mmmmm! It's ready to eat!",
        -- EMPTY = "He never leaves home without it.",
    -- },

	-- WARLY = 
    -- {
        -- GENERIC = "Good day, %s!",
        -- ATTACKER = "%s looks like they're planning to cook me!",
        -- MURDERER = "%s has been overcooked!",
        -- REVIVER = "%s is cooking up friendships.",
        -- GHOST = "Looks like you've been cooked, %s.",
		-- FIRESTARTER = "I think you're cooking the wrong stuff, %s.",
    -- },
    --

	SEAWEED_STALK = "Should plant this somewhere.", --copied from the Wikia because I couldn't find it in the game files. -M

	WILDBOREGUARD = "What's it guarding?",
	SOLOFISH_DEAD = "Good dog.",
	FISH_MED_COOKED = "Grilled to perfection.",
	PURPLE_GROUPER = "A fish with widespread appeal.",
	PURPLE_GROUPER_COOKED = "Avoid the green ones, they're not ripe yet.",

	GHOST_SAILOR = "I wonder what he wants?",
	FLOTSAM = "If only I had some way of hooking on to it from here.",
	SUNKEN_BOAT = 
	{
		GENERIC = "That fellow looks like he wants to talk.",
		ABANDONED = "This is why I hate the water.",
	},
	SUNKEN_BOAT_BURNT = "It's even less seaworthy than before.",
	SUNKEN_BOAT_TRINKET_1 = "An instrument of some sort.", --sextant
	SUNKEN_BOAT_TRINKET_2 = "Now all I need is a miniaturization machine!", --toy boat
	SUNKEN_BOAT_TRINKET_3 = "Looks kinda soggy.", --candle
	SUNKEN_BOAT_TRINKET_4 = "Scientific!", --sea worther
	SUNKEN_BOAT_TRINKET_5 = "If only I had another!", --boot
	SUNKBOAT = "It's no use to me out there!",
	-- BANANAPOP = "No, not brain freeze! I need that for science!",
	BISQUE = "Cooking that sure kept me bisque-y!",
	-- CEVICHE = "Can I get a bigger bowl? This one looks a little shrimpy.",
	SEAFOODGUMBO = "It's a jumbo seafood gumbo.",
	SURFNTURF = "It's perf!",
	SHARKFINSOUP = "It's shark fin-ished!",
	LOBSTERDINNER = "If I eat it in the morning is it still dinner?",
	LOBSTERBISQUE = "Could use more salt, but that's none of my bisque-ness.",
	JELLYOPOP = "Jelly-O pop it right in my mouth!",

	BOAT_ENCRUSTED = "A mere shell of a ship.",
	BABYOX = "Smaller, but just as smelly.",
	BALLPHINHOUSE = "The place where the ballphins roost.",
	DORSALFIN = "Guess that house is FINished.",
	NUBBIN = "I want nubbin to do with that.",
	CORALLARVE = "That's a baby coral reef.",
	RAINBOWJELLYFISH = "That's a lot of tendrils.",
	RAINBOWJELLYFISH_PLANTED = "A colorful blob of science.",
	RAINBOWJELLYFISH_DEAD = "An electric shock will not revive it. I tried.",
	RAINBOWJELLYFISH_COOKED = "A colorful snack!",
	RAINBOWJELLYJERKY = "All the water's dried right out of it.",
	WALL_ENFORCEDLIMESTONE = "I shelled out for the good stuff.",
	WALL_ENFORCEDLIMESTONE_ITEM = "I have to build it in the water.",
	CROCODOG = "I'd rather stay away from the business end of that jerk.",
	POISONCROCODOG = "That looks like an experiment gone wrong.",
	WATERCROCODOG = "It's a dog-eat-me world out here.",
	QUACKENBEAK = "I'd say I made the pecking order around here quite clear.",
	QUACKERINGRAM = "Does my ingenuity know no bounds?!",

	CAVIAR = "I never had it before I came here.",
	CORMORANT = "I bet it eats a lot of fish.",

	PURPLE_GROUPER = "Surf and turf, hold the turf.",
	PIERROT_FISH = "This one's extra water repellent.",
	NEON_QUATTRO = "It looks like a fish, but it feels clammy.",

	PURPLE_GROUPER_COOKED = "That fish is fin-ished.",
	PIERROT_FISH_COOKED = "Gilled to perfection.",
	NEON_QUATTRO_COOKED = "Fried fry.",

	FISH_FARM = 
	{
		EMPTY = "I need to find some fish eggs for this.",
		STOCKED = "The fish babies haven't hatched yet.",
		ONEFISH = "There's a fish!",
		TWOFISH = "The fish are still multiplying.",
		REDFISH = "This has been a successful fish experiment!",
		BLUEFISH  = "I'd better start harvesting these!",
	},

	ROE = "Fish babies.",
	ROE_COOKED = "Roe, sunny side up.",
	
	SEA_YARD =
	{
		ON = "For keeping my ships in tiptop shape!",
		OFF = "It's not in shipshape right now.",
		LOWFUEL = "I'll need to refill it soon.",
	},

	SEA_CHIMINEA = 
	{
		EMBERS = "Better put something on it before it goes out.",
		GENERIC = "Science protect my fires out here.",
		HIGH = "I'm glad we're surrounded by water.",
		LOW = "It's getting low.",
		NORMAL = "As cozy as it gets.",
		OUT = "It finally went out.",
	}, 

	TAR = "Do I have to hold it with my bare hands?",
	TAR_EXTRACTOR =
	{
		ON = "It's running smoothly.",
		OFF = "I have to turn it on.",
		LOWFUEL = "I need to refuel that.",
	},
	TAR_POOL = "There must be a way to get that tar out.",

	TARLAMP = "That's a real slick lamp.",
	TARSUIT = "I'll pitch a fit if I have to wear that.",
	TAR_TRAP = "Who's cleaning that up, I wonder?",

	TROPICALBOUILLABAISSE = "I seasoned it with a dash of science.",

	SEA_LAB = "For sea science!",
	WATERCHEST = "Watertight, just like all my theories.",
	QUACKENDRILL = "I can get more tar if I used this at sea.",
	HARPOON = "I don't intend to harp on the issue.",
	MUSSEL_BED = "I should find a good spot for these.",
	ANTIVENOM = "Tastes horrible!",
	VENOMGLAND = "Only poison can cure poison.",
	BLOWDART_POISON = "The pointy end goes that way.",
	OBSIDIANMACHETE = "It's hot to the touch.",
	SPEARGUN_POISON = "Poison tipped.",
	OBSIDIANSPEARGUN = "Fire tipped.",
	LUGGAGECHEST = "It looks like a premier steamer trunk.",
	PIRATIHATITATOR =
	{
		GENERIC = "It's twisting my tongue.",
		BURNT = "Fire doesn't really solve naming issues...",
	},
	COFFEEBEANS = "They could use some roasting.",
	COFFEE = "Smells delicious and energizing!",
	COFFEEBEANS_COOKED = "Heat definitely improved them.",
	COFFEEBUSH =
	{
		BARREN = "I think it needs to be fertilized.",
		WITHERED = "Looks malnourished.",
		GENERIC = "This is a plant I could learn to love.",
		PICKED = "Maybe they'll grow back?",
	},
	COFFEEBOT = "It's a coffee maker.",
	MUSSEL = "Could use some flexing.",
	MUSSEL_FARM =
	{
		 GENERIC = "I wonder if they are from Brussels.",
		 STICKPLANTED = "I really stuck it to them."
	},

	MUSSEL_STICK = "I'm really going to stick it to those mussels.",
	LOBSTER = "What a Wascally Wobster.",
	LOBSTERHOLE = "That Wascal is sleeping.",
	SEATRAP = "For the deadliest catch.",
	SANDCASTLE =
	{
		SAND = "It's a sandcastle, in the sand!",
		GENERIC = "Look what I made!"
	},
	BOATREPAIRKIT = "This will add some float to my boat.",

	BALLPHIN = "Such a round, rubbery fellow.",
	BOATCANNON = "The only thing better than a boat is a boat with a cannon.",
	BOTTLELANTERN = "A bottle full of sunshine.",
	BURIEDTREASURE = "Please be a good treasure!",
	BUSH_VINE =
	{
		BURNING = "Whoops.",
		BURNT = "I feel like I could have prevented that.",
		CHOPPED = "Take that, nature!",
		GENERIC = "It's all viney!",
	},
	CAPTAINHAT = "The proper boating attire!",
	COCONADE =
	{
		BURNING = "This seems dangerous.",
		GENERIC = "I'll need to light it first.",
	},
	CORAL = "Living building material!",
	ROCK_CORAL = "The coral's formed a reef!",
	CRABHOLE = "They call a hole in the sand their home.",
	CUTLASS = "I hope this sword doesn't start to smell...",
	DUBLOON = "I'm rich!",
	FABRIC = "Soft cloth made from hard roots!",
	FISHINHOLE = "This area seems pretty fishy.",
	GOLDENMACHETE = "Hack in style!",
	JELLYFISH = "This creature is pure science!",
	JELLYFISH_DEAD = "It lived a good life. Maybe.",
	JELLYFISH_COOKED = "It's all wriggly.",
	JELLYFISH_PLANTED = "Science works in mysterious, blobby ways.",
	JELLYJERKY = "I'd be a jerk not to eat this.",

	ROCK_LIMPET =
	{
		GENERIC = "I could fill a pail with all those snails.",
		PICKED = "I can't fill a pail without snails.",
	},
	BOAT_LOGRAFT = "This looks... sort of boat-like...",
	MACHETE = "I like the cut of this blade.",
	MESSAGEBOTTLEEMPTY = "Just an empty bottle.",
	MOSQUITO_POISON = "These blasted mosquitoes carry a terrible sickness.",
	OBSIDIANCOCONADE = "It's even bombier!",
	OBSIDIANFIREPIT =
	{
		EMBERS = "I should put something on the fire before it goes out.",
		GENERIC = "This fire pit is a conductor for even more... fire.",
		HIGH = "Good thing it's contained!",
		LOW = "The fire's getting a bit low.",
		NORMAL = "This is my best invention yet.",
		OUT = "At least I can start it up again.",
	},
	OX = "These creatures seem reasonable.",
	PIRATEHAT = "Fit for a cutthroat scallywag. Or me.",
	BOAT_RAFT = "This looks adequate.",
	BOAT_ROW = "It runs on elbow grease.",
	SAIL_PALMLEAF = "This should really transform my boating experience.",
	SANDBAG_ITEM = "Sand technology, on the go.",
	SANDBAG = "Keeps the water at bay.",
	SEASACK = "I hate when food has that not-so-fresh taste.",
	SEASHELL_BEACHED = "Sea refuse.",
	SEAWEED = "A weed. Of the sea.",

	SEAWEED_PLANTED = "Is that what passes for food around here?",
	SLOTMACHINE = "I suppose I could linger for a moment or two.",
	SNAKE_POISON = "Even worse than a regular snake!",
	SNAKESKIN = "I'm intrigued AND repelled.",
	SNAKESKINHAT = "It should repel the rain from my hair.",
	SOLOFISH = "It has that wet-dog smell.",
	SPEARGUN = "Oh, the science I could get up to with this!",
	SPOILED_FISH = "I'm not terribly curious about the smell.",
	SWORDFISH = "I think this fish evolved to run me through.",
	TRIDENT = "I wonder how old this artifact is?",
	TRINKET_IA_13 = "What is this substance?",
	TRINKET_IA_14 = "This thing gives me the creeps...",
	TRINKET_IA_15 = "Incredible! This guitar has undergone shrinkification!",
	TRINKET_IA_16 = "How did this get all the way out here?",
	TRINKET_IA_17 = "Where's the other one?",
	TRINKET_IA_18 = "A relic of a bygone era!",
	TRINKET_IA_19 = "Clouding of the brain. Never heard of it...",
	TURBINE_BLADES = "Perhaps this powered that beastly storm?",
	TURF_BEACH = "Sandy ground.",
	TURF_JUNGLE = "Very gnarled ground.",
	VOLCANO_ALTAR =
	{
		GENERIC = "It appears to be closed.",
		OPEN = "The altar is open and ready to accept offerings!",
	},
	VOLCANO_ALTAR_BROKEN = "Er, that won't be a problem, will it?",
	WHALE_BLUE = "That whale has emotional issues.",
	WHALE_CARCASS_BLUE = "Gross. I think the bloating has begun.",
	WHALE_CARCASS_WHITE = "Gross. I think the bloating has begun.",

	ARMOR_SNAKESKIN = "How fashionable!",
	SAIL_CLOTH = "That wind isn't getting away now!",
	DUG_COFFEEBUSH = "This belongs in the ground!",
	LAVAPOOL = "A bit hot for my tastes.",
	BAMBOO = "Maybe I can bamboozle my enemies with this?",
	AERODYNAMICHAT = "It really cuts through the air!",
	POISONHOLE = "I think I'll stay away from that.",
	BOAT_LANTERN = "This will do wonders for my night vision!",
	SWORDFISH_DEAD = "I better not run with this.",
	LIMPETS = "Maybe starving wouldn't be so bad.",
	OBSIDIANAXE = "A winning combination!",
	COCONUT = "It requires a large nut hacker.",
	COCONUT_SAPLING = "It doesn't need my help to grow anymore.",
	COCONUT_COOKED = "Now I just need a cake.",
	BERMUDATRIANGLE = "Gives me an uneasy feeling.",
	SNAKE = "I wonder if it'll sell me some oil?",
	SNAKEOIL = "The label says \"Jay's Wondrous Snake Oil!\"",
	ARMORSEASHELL = "Arts and crafts!",
	SNAKE_FIRE = "Is that snake smoldering?",
	MUSSEL_COOKED = "I cook a mean mussel.",

	PACKIM_FISHBONE = "This seems like something I should carry around.",
	PACKIM = "I bet I could pack'im full of stuff.",

	ARMORLIMESTONE = "I'm sure this will hold up great!",
	TIGERSHARK = "Well that's terrifying.",
	WOODLEGS_KEY1 = "Something, somewhere must be locked.",
	WOODLEGS_KEY2 = "This key probably unlocks something.",
	WOODLEGS_KEY3 = "That's a key.",
	WOODLEGS_CAGE = "That seems like an excessive amount of locks.",
	OBSIDIAN_WORKBENCH = "I feel inspired.",

	NEEDLESPEAR = "I'm glad I didn't step on this.",
	LIMESTONENUGGET = "Could be a useful building material.",
	DRAGOON = "You're a quick one, aren't you?",

	ICEMAKER = 
	{
		OUT = "It needs more fuel.",
		VERYLOW = "I can hear it sputtering.",
		LOW = "It seems to be slowing down.",
		NORMAL = "It's putting along.",
		HIGH = "It's running great!",
	},

	DUG_BAMBOOTREE = "I need to plant this.",
	BAMBOOTREE =
	{
		BURNING = "Bye bye, bamboo.",
		BURNT = "I feel like I could have prevented that.",
		CHOPPED = "Take that, nature!",
		GENERIC = "Golly, it's even floatier than wood!", --"Looks pretty sturdy.", -Mob
	},
	
	JUNGLETREE =
	{
		BURNING = "What a waste of wood.",
		BURNT = "I feel like I could have prevented that.",
		CHOPPED = "Take that, nature!",
		GENERIC = "That tree needs a hair cut.",
	},
	SHARK_GILLS = "I wish I had gills.",
	LEIF_PALM = "Someone gimme a hand with this palm!",
	OBSIDIAN = "It's a fire rock.",
	BABYOX = "It's a tiny meat beast.",
	STUNGRAY = "I think I'll keep my distance.",
	SHARK_FIN = "A sleek fin.",
	FROG_POISON = "It looks meaner than usual.",
	BOAT_ARMOURED = "That is one durable boat.",
	ARMOROBSIDIAN = "I'm a genius.",
	BIOLUMINESCENCE = "These make a soothing glow.",
	SPEAR_POISON = "Now it's extra deadly.",
	SPEAR_OBSIDIAN = "This will leave a mark.",
	SNAKEDEN =
	{
		BURNING = "Whoops.",
		BURNT = "I feel like I could have prevented that.",
		CHOPPED = "Take that, nature!",
		GENERIC = "It's all viney!",
	},
	TOUCAN = "I tou-can't catch him.",
	MESSAGEBOTTLE = "Someone wrote me a note!",
	SAND = "A handy pile of pocket sand.",
	SANDDUNE = "You better stay out of my shoes.",
	PEACOCK = "Nothing more than a dressed up thief.",
	VINE = "Maybe I can tie stuff up with this.",
	SUPERTELESCOPE = "I can see forever!",
	SEAGULL = "Shoo! Find some other land!",
	SEAGULL_WATER = "Shoo! Find some other water!",
	PARROT = "I find myself fresh out of crackers.",
	ARMOR_LIFEJACKET = "Keeps me afloat, without my boat!",
	WHALE_BUBBLES = "Something's underwater here.",
	EARRING = "The fewer holes in my body, the better.",
	ARMOR_WINDBREAKER = "The wind doesn't stand a chance!",
	SEAWEED_COOKED = "Crispy.",
	BOAT_CARGO = "It has room for all my stuff!",
	GASHAT = "Sucks all the stink out.",
	ELEPHANTCACTUS = "Yikes! I could poke an eye out!",
	DUG_ELEPHANTCACTUS = "A portable poker plant.",
	ELEPHANTCACTUS_ACTIVE = "That cactus seems abnormally pokey.",
	ELEPHANTCACTUS_STUMP = "It'll sprout pokers again eventually.",
	SAIL_FEATHER = "It's feather-light!",
	WALL_LIMESTONE_ITEM = "These would do more good if I placed them.",
	JUNGLETREESEED = "I can hear the hissing of tiny snakes.",
	JUNGLETREESEED_SAPLING = "It will grow into a nice jungle tree.",
	VOLCANO = "My scientific know-how tells me that's a perfectly safe mountain!",
	IRONWIND = "This is how a scientist should travel.",
	SEAWEED_DRIED = "Salty!",
	TELESCOPE = "I spy with my little eye...",
	
	DOYDOY = "I feel oddly protective of this dumb bird.",
	DOYDOYBABY = "What a cute little, uh, thing.",
	DOYDOYEGG = "Maybe I should have let it hatch.",
	DOYDOYEGG_CRACKED = "Oh well. I'm sure there are lots more!",
	DOYDOYFEATHER = "Soft AND endangered!",

	PALMTREE =
	{
		BURNING = "What a waste of wood.",
		BURNT = "I feel like I could have prevented that.",
		CHOPPED = "Take that, nature!",
		GENERIC = "How tropical.",
	},
	PALMLEAF = "I'm fond of these fronds.",
	CHIMINEA = "Take that, wind!",
	DOUBLE_UMBRELLAHAT = "The second umbrella keeps the first umbrella dry.",
	CRAB = 
	{
		GENERIC = "Don't get snappy with me, mister.",
		HIDDEN = "I wonder where that crabbit went?",
	},
	TRAWLNET = "Nothing but net.",
	TRAWLNETDROPPED = 
	{
		SOON = "It is definitely sinking.",
		SOONISH = "I think it's sinking.",
		GENERIC = "It's bulging with potential!",
	},
	VOLCANO_EXIT = "There's a cool breeze blowing in from outside.",
	SHARX = "These things sure are persistent.",
	SEASHELL = "Maybe I could sell these.",
	WHALE_BUBBLES = "Something down there has bad breath.",
	MAGMAROCK = "I can dig it.",
	MAGMAROCK_GOLD = "I see a golden opportunity.",
	CORAL_BRAIN_ROCK = "I wonder what it's plotting...",
	CORAL_BRAIN = "Food for thought.",
	SHARKITTEN = "You've got to be kitten me!",
	SHARKITTENSPAWNER = 
	{
		GENERIC = "Is that sand pile purring?",
		INACTIVE = "That is a rather large pile of sand.",
	},
	LIVINGJUNGLETREE = "Just like any other tree.",
	WALLYINTRO_DEBRIS = "Part of a wrecked ship.",
	MERMFISHER = "You better not try anything fishy.",
	PRIMEAPE = "Those things are going to be the end of me.",
	PRIMEAPEBARREL = "Here be evil.",
	BARREL_GUNPOWDER = "How original.",
	PORTAL_SHIPWRECKED = "It's broken.",
	MARSH_PLANT_TROPICAL = "Planty.",
	TELEPORTATO_SW_POTATO = "Seems like it was made with a purpose in mind.",
	PIKE_SKULL = "Ouch.",
	PALMLEAF_HUT = "Shade, sweet shade.",
	FISH_SMALL_COOKED = "A small bit of cooked fish.",
	LOBSTER_DEAD = "You should cook up nicely.",
	MERMHOUSE_FISHER = "Doesn't smell very good.",
	WILDBORE = "Looks aggressive.",
	PIRATEPACK = "I can keep my booty in here.",
	TUNACAN = "Where did this can come from?",
	MOSQUITOSACK_YELLOW = "Part of a yellow mosquito.",
	SANDBAGSMALL = "This should keep the water out.",
	FLUP = "Leave me alone!",
	OCTOPUSKING = "I'm a sucker for this guy.",
	OCTOPUSCHEST = "I hope that thing is waterproof.",
	GRASS_WATER = "I hope you're thirsty, grass.",
	WILDBOREHOUSE = "What a bore-ing house.",
	FISH_SMALL = "A small bit of fish.",
	TURF_SWAMP = "Swampy turf.",
	FLAMEGEYSER = "Maybe I should stand back.",
	KNIGHTBOAT = "Get off the waterway, you maniac!",
	MANGROVETREE_BURNT = "I wonder how that happened.",
	TIDAL_PLANT = "Look. A plant.",
	WALL_LIMESTONE = "Sturdy.",
	FISH_MED = "A chunk of fish meat.",
	LOBSTER_DEAD_COOKED = "I can't wait to eat you.",
	BLUBBERSUIT = "Well, it's something.",
	BLOWDART_FLUP = "Eye see.",
	TURF_MEADOW = "Meadow-y turf.",
	TURF_VOLCANO = "Volcano-y turf.",
	SWEET_POTATO = "Looks yammy!",
	SWEET_POTATO_COOKED = "Looks even yammier!",
	SWEET_POTATO_PLANTED = "That's an odd looking carrot.",
	SWEET_POTATO_SEEDS = "My very own plant eggs.",
	BLUBBER = "Squishy.",
	TELEPORTATO_SW_RING = "Looks like I could use this.",
	TELEPORTATO_SW_BOX = "It looks like a part for something.",
	TELEPORTATO_SW_CRANK = "I wonder what this is used for.",
	TELEPORTATO_SW_BASE = "I think it's missing some parts.",
	VOLCANOSTAFF = "The label says \"Keep out of reach of children.\"",
	THATCHPACK = "I call it a thatchel.",
	SHARK_TEETHHAT = "What a dangerous looking hat.",
	TURF_ASH = "Ashy turf.",
	BOAT_TORCH = "This'll keep my hands free.",
	MANGROVETREE = "I wonder if it's getting enough water?",
	HAIL_ICE = "Chilling.",
	FISH_TROPICAL = "What a tropical looking fish.",
	TIDALPOOL = "A pool, left by the tides.",
	WHALE_WHITE = "Looks like a fighter.",
	VOLCANO_SHRUB = "You look ashen.",
	ROCK_OBSIDIAN = "Blast it! It won't be mined!",
	ROCK_CHARCOAL = "Would need an awfully big stocking for that.",
	DRAGOONDEN = "Even goons gotta sleep.",
	WILBUR_UNLOCK = "He looks kind of regal.",
	WILBUR_CROWN = "It's oddly monkey-sized.",
	TWISTER = "I thought it was strangely windy around here.",
	TWISTER_SEAL = "D'awww.",
	MAGIC_SEAL = "This is a powerful artifact.",
	SAIL_STICK = "There must be a scientific explanation for this.",
	WIND_CONCH = "I can hear the wind trapped within.",
	DRAGOONEGG = "Do I hear cracking?",
	BUOY = "Awww yaaaaa buoy!", 
	TURF_SNAKESKIN = "Sssstylish ssssstatement.",
	DOYDOYNEST = "It's for doydoy eggs, dummy.",
	ARMORCACTUS = "The best defense is a good offense.",
	BIGFISHINGROD = "To catch a big fish, you need a big rod.",
	BRAINJELLYHAT = "Two brains means double the ideas!",
	COCONUT_HALVED = "When I click them together, they make horsey sounds.",
	CRATE = "There must be a way to open it.",
	DEPLETED_BAMBOOTREE = "Will it grow again?",
	DEPLETED_BUSH_VINE = "One day it may return.",
	DEPLETED_GRASS_WATER = "Farewell, sweet plant.",
	DOYDOYEGG_COOKED = "A controlled chemical reaction has made this egg matter more nutritious.",
	DRAGOONHEART = "Where the dragoon once stored its feelings.",
	DRAGOONSPIT = "It's SPITacularly disgusting!",
	DUG_BUSH_VINE = "I suppose I should pick it up.",
	-- FRESHFRUITCREPES = "Sugary fruit! Part of a balanced breakfast.",
	KRAKEN = "Now's not the time for me to be Quacken wise!",
	KRAKENCHEST = "To the victor, the spoils.",
	KRAKEN_TENTACLE = "A beast that never sleeps.",
	MAGMAROCK_FULL = "I can dig it.",
	MAGMAROCK_GOLD_FULL = "I see a golden opportunity.",
	MONKEYBALL = "I have a strange desire to name it after myself.",
	-- MONSTERTARTARE = "There's got to be something else to eat around here.",
	MUSSELBOUILLABAISE = "Imagine the experiments I could run on it!",
	MYSTERYMEAT = "I'm not dissecting that.",
	OXHAT = "Nice and dry. This helmet will protect me from the elements.",
	OX_FLUTE = "Is it dripping...?",
	OX_HORN = "I grabbed the ox by the horn.",
	PARROT_PIRATE = "I try not to eat anything with a name.",
	PEG_LEG = "I can perform amputations if anyone'd like to wear it for real.",
	PIRATEGHOST = "He met a terrible end. I will too if I don't get out of here.",
	SANDBAGSMALL_ITEM = "A bag full of sand. Does science know no bounds?",
	SHADOWSKITTISH_WATER = "Yikes!",
	SHIPWRECKED_ENTRANCE = "Ahoy!",
	SHIPWRECKED_EXIT = "And so, I sail away into the horizon!",
	SAIL_SNAKESKIN = "Scale it and sail it!",
	SPEAR_LAUNCHER = "Science takes care of me.",
	SWEETPOTATOSOUFFLE = "Sweet potato souffles are a rising trend.",
	SWIMMINGHORROR = "Yikes! Get me back to land!",
	TIGEREYE = "More eyes means better sight... right?",
	TRINKET_IA_20 = "I'm not sure what it is, but it makes me feel smarter!",
	TRINKET_IA_21 = "I ought to measure it to ensure it's to scale.",
	TRINKET_IA_22 = "I'm sure someone would like this.",
	TURF_MAGMAFIELD = "Lava-y floor.",
	TURF_TIDALMARSH = "Marsh-y floor.",
	VOLCANO_ALTAR_TOWER = "How scary!",
	WATERYGRAVE = "Sure, I could fish it out of there. But should I?",
	WHALE_TRACK = "Whale, ho!",
	WILDBOREHEAD = "It smells as bad as it looks.",
	BOAT_WOODLEGS = "A vessel fit for a scallywag.",
	WOODLEGSHAT = "Does it make me look scurvy... I mean scary!?",
	SAIL_WOODLEGS = "The quintessential pirate sail.",
	SHIPWRECK = "Poor little boat.",
	INVENTORYGRAVE = "There was someone here before me!",
	INVENTORYMOUND = "There was someone here before me!",
	LIMPETS_COOKED = "Escargotcha!",
	RAWLING = "It's my buddy!",
	CALIFORNIAROLL = "But I don't have chopsticks.",
},
}
