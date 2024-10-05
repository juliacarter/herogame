extends Node
class_name GameData

@onready var rules = get_node("/root/WorldVariables")





var tags = {
	"health": Tag.new("health", "restoration"),
	"energy": Tag.new("energy", "restoration"),
	"food": Tag.new("food", "restoration"),
	"loyalty": Tag.new("loyalty", "restoration"),
	
	"table": Tag.new("table", "accessory"),
	
	"power": Tag.new("power", "objective"),
	"command": Tag.new("command", "objective"),
	
	"computer": Tag.new("computer", "science"),
	"microscope": Tag.new("microscope", "science"),
}



var fuels = {
	"health": {
		"name": "Strength",
		"num": 200,
		"category": "basic",
		"newtarget": 10
	},
	"energy": {
		"name": "Energy",
		"num": 50,
		"category": "basic",
		"newtarget": 10
	},
	"loyalty": {"name": "Loyalty",
		"num": 50,
		"category": "basic",
		"abdata": [
			{
				"ability": "waveringloyalty",
				"threshold": 20,
				"threshold_above": false
			},
			{
				"ability": "goodloyalty",
				"threshold": 40,
				"threshold_above": true,
				"bracket": 1
			}
		],
		"newtarget": 10
	},
	"food": {
		"name": "Food",
		"num": 50,
		"category": "basic",
		"newtarget": 10
	},
	"attention": {"name": "Attention",
		"num": 2,
		"category": "basic",
		"newtarget": 10,
		"autofill": true,
	},
}

var qualities = {
	"strength": {"name": "Strength", "num": 10, "category": "basic",
		"abdata": [
			{
				"ability": "strengthbonus",
				"bracket": 1,
			}
		],
	},
	"agility": {"name": "Agility", "num": 10, "category": "basic",
		"influences": {
			"agilityspeed": 0.5,
			"gunaccuracy": 0.2,
			}
	},
	"knowledge": {"name": "Knowledge", "num": 10, "category": "basic",
		"influences": {
			"knowledgespeed": 0.5
			}
	},
	"perception": {"name": "Perception", "num": 10, "category": "basic",
		"influences": {
			"perceptionspeed": 0.5
			}
	},
	"guile": {"name": "Guile", "num": 10, "category": "basic",
		"influences": {
			"guilespeed": 0.5
			}
	},
	"charisma": {"name": "Charisma", "num": 10, "category": "basic",
		"influences": {
			"charismaspeed": 0.5
			}
	},
}

var skills = {
	"scanning": {"name": "Scanning", "num": 0, "category": "command",
		"growthrate": 0.5,
		"decayrate": 0.2,
		"influences": {
			"scanningspeed": 1
			}
	},
	"machines": {"name": "Machine Operation", "num": 0, "category": "command",
		"growthrate": 0.5,
		"decayrate": 0.2,
		"influences": {
			"machinefficiency": 1
			}
	},
}

var weapons = {
	#"weapon": {
	#	"range": range in squares
	#	"damage": {
	#			"damagetype": [
	#				{"stat": stat being damaged, "type": what armor it's resisted by, "min": bonus for the attack, "variance": dice size for the attack}
	#				]
	#		},
	#	"accuracy": modifier added to the accuracy value,
	#	"aimtime": how many seconds to aim,
	#	"readytime": how many seconds to ready,
	#	"rangepenalty": modifier removed from accuracy value at maximum range,
	#	"firetime": how many seconds to fire each attack,
	#	"attackcount": number of attacks made per cycle
	#},
	"pistol": {
		"range": 10.0,
		"damage": {
				"kinetic": [
					{"stat": "health", "type": "kinetic", "min": 8, "variance": 4}
					]
			},
		"accuracy": 10,
		"accmods": ["shooting_accuracy"],
		"aimtime": 0.0,
		"readytime": 0.75,
		"rangepenalty": 25,
		"firetime": 0.3,
		"attackcount": 1
	},
	"rifle": {
		"range": 7.0,
		"damage": {
				"kinetic": [
					{"stat": "health", "type": "kinetic", "min": 24, "variance": 6}
					]
			},
		"accuracy": 10,
		"aimtime": 1.0,
		"readytime": 1.0,
		"rangepenalty": 15,
		"firetime": 0.3,
		"attackcount": 1
	},
	"machinegun": {
		"range": 5.0,
		"damage": {
				"kinetic": [
					{"stat": "health", "type": "kinetic", "min": 7, "variance": 2}
					]
			},
		"accuracy": 10,
		"aimtime": 0.5,
		"readytime": 1.0,
		"rangepenalty": 25,
		"firetime": 0.2,
		"attackcount": 3
	},
	
	"claw": {
		"damage": {
				"kinetic": [
					{"stat": "health", "type": "bludgeon", "min": 6, "variance": 4}
					],
			},
		"accuracy": 10,
		"aimtime": 0.0,
		"readytime": 1.0, 
		"rangepenalty": 25,
		"firetime": 0.1,
		"attackcount": 1
	},
	"sword": {
		"damage": {
				"bludgeon": [
					{"stat": "health", "type": "bludgeon", "min": 12, "variance": 16}
					],
			},
		"accuracy": 10,
		"aimtime": 0.0,
		"readytime": 1.0, 
		"rangepenalty": 25,
		"firetime": 0.1,
		"attackcount": 1
	},
	"beam": {
		"range": 5.0,
		"damage": {
				"energy": [
					{"stat": "health", "type": "energy", "min": 2, "variance": 0}
					]
			},
		"accuracy": 30,
		"aimtime": 0.2,
		"readytime": 0.2, 
		"rangepenalty": 25,
		"firetime": 0.2,
		"attackcount": 8
	},
	
	"phantomstrike": {
		"damage": {
				"bludgeon": [
					{"stat": "health", "type": "bludgeon", "min": 10, "variance": 0}
					],
			},
		"accuracy": 10,
		"triggers": {
			"attack_hit": [
				{
					"action": "apply_buff",
					"conditions": [
						{
							"type": "MeleeAttackCondition",
							"value": true,
							"by_parent": false,
						}
					],
					"includes": true,
					"args": ["phantom", 1],
				}
			]
		},
		#"dammods": ["melee_power", "melee_power"],
		"aimtime": 0.0,
		"readytime": 1.0, 
		"rangepenalty": 25,
		"firetime": 0.1,
		"attackcount": 1
	},
	
	
	#MARTIAL ARTS
	
	"tigerjaw": {
		"damage": {
				"bludgeon": [
					{"stat": "health", "type": "bludgeon", "min": 0, "variance": 0}
					],
			},
		"accuracy": 10,
		"triggers": {
			"damage_rolled": [
				{
					"action": "apply_self_buff",
					"includes": true,
					"by_parent": true,
					"args": ["poison", 10],
				}
			]
		},
		"dammods": ["melee_power", "melee_power"],
		"aimtime": 0.0,
		"readytime": 1.0, 
		"rangepenalty": 25,
		"firetime": 0.1,
		"attackcount": 1
	},
	
	"thunderkick": {
		"damage": {
				"bludgeon": [
					{"stat": "health", "type": "bludgeon", "min": 2, "variance": 4}
					],
			},
		"accuracy": 10,
		"dammods": ["melee_power", "melee_power"],
		"aimtime": 0.0,
		"readytime": 1.0, 
		"rangepenalty": 25,
		"firetime": 0.1,
		"attackcount": 1
	},
	
	#NATURAL MELEE
	
	"fists": {
		"damage": {
				"bludgeon": [
					{"stat": "health", "type": "bludgeon", "min": 0, "variance": 0}
					],
			},
		"accuracy": 10,
		"dammods": ["melee_power", "melee_power"],
		"aimtime": 0.0,
		"readytime": 1.0, 
		"rangepenalty": 25,
		"firetime": 0.1,
		"attackcount": 1
	},
	
}

var armors = {
	"flak": {"armor": {
		"bludgeon": {"min": 0, "variance": 10}, "kinetic": {"min": 0, "variance": 10}
		}, "durability": 50},
	"gasmask": {"armor": {
		"enviro": {"min": 5, "variance": 0}
		}, "durability": 10},
	"justicejacket": {
		"armor": {
		"bludgeon": {"min": 50000, "variance": 0}, "kinetic": {"min": 50000, "variance": 0}
		}, "durability": 50
	}
}

var items_to_load = {
	"ore": {"name": "ore", "size": 1, "cat": ["debug"], "price": 2, "sprite": "ore", "type": "resource"},
	"metal": {"name": "metal", "size": 1, "cat": ["debug"], "price": 1, "sprite": "metal", "type": "resource"},
	"acid": {"name": "acid", "size": 1, "cat": ["debug"], "price": 2, "sprite": "thang", "type": "resource"},
	
	"mealpaste": {"name": "Meal Paste", "size": 1, "cat": ["debug"], "price": 2, "sprite": "thang", "type": "consumable"},
	
	#EQUIPMENT
	"sword": {
		"name": "Sword",
		"sprite": "thang",
		"abilities": [
			"swordability"
		],
		"size": 1,
		"cat": ["debug"],
		"price": 5,
		"slot": "weapon",
		"wearsprite": "thang",
		"type": "equipment"
	},
	"rifle": {
		"name": "Rifle",
		"sprite": "rifle",
		"attack": "rifle",
		"abilities": [
			"rifleability"
		],
		"size": 1,
		"cat": ["debug"],
		"price": 5,
		"slot": "weapon",
		"wearsprite": "rifle",
		"type": "weapon"
	},
	"popper": {
		"name": "Popper Pistol",
		
		#"attack": "pistol",
		"size": 1,
		"cat": ["debug"],
		"abilities": [
			"pistolability"
		],
		"price": 5,
		"slot": "weapon",
		"sprite": "pistol",
		"wearsprite": "pistol",
		"type": "weapon"
	},
	
	"raygun": {
		"name": "Raygun",
		"attack": "beam",
		"size": 1,
		"cat": ["debug"],
		"abilities": [
			"beamability"
		],
		"price": 5,
		"slot": "weapon",
		"sprite": "gun1",
		"wearsprite": "gun1",
		"type": "weapon"
	},
	
	"studder": {
		"name": "Studder SMG",
		"reqcost": 10,
		"attack": "machinegun",
		"size": 1,
		"abilities": [
			"machinegunability"
		],
		"cat": ["debug"],
		"price": 5,
		"slot": "weapon",
		"sprite": "studder",
		"wearsprite": "studder",
		"type": "weapon"
	},
	"flakjacket": {
		"name": "flakjacket",
		"size": 1,
		"cat": ["debug"],
		"abilities": [
			"flakability"
		],
		"price": 5,
		"slot": "armor",
		"sprite": "kevlar",
		"wearsprite": "kevlar",
		"type": "armor"
	},
	"justicejacket": {
		"name": "justicejacket",
		"protection": "justicejacket",
		"size": 1,
		"cat": ["debug"],
		"abilities": [
			"justicejacketability"
		],
		"price": 5,
		"slot": "armor",
		"sprite": "kevlar",
		"wearsprite": "kevlar",
		"type": "armor"
	},
	"bighat": {
		"name": "bighat",
		"protection": "flak",
		"size": 1,
		"cat": ["debug"],
		"abilities": [
			"flakability"
		],
		"price": 5,
		"slot": "head",
		"sprite": "hat",
		"wearsprite": "hat",
		"type": "armor"
	},
	"gasmask": {
		"name": "bighat",
		"protection": "gasmask",
		"abilities": [
			"gasmaskability"
		],
		"size": 1,
		"cat": ["debug"],
		"price": 5,
		"slot": "head",
		"sprite": "gasmask",
		"wearsprite": "gasmask",
		"type": "armor"
	},
}

var cats = [
	"furniture",
	"healers",
	"containers",
	"infrastructure",
	"doors",
	"tiles",
	"traps",
	"cameras",
	"itemspawn",
	"minspawn",
]

var powcatnames = [
	"debug",
	"minspawn",
	"itemspawn",
	"zones",
	"spells",
	"waypoints",
]
var powcats =[]

var toolcats = []

var powers_to_load = {
	"spawnmin": {"name": "Spawn Minion", "on_cast": "place_unit_at_cursor", "cast_args": ["minion"], "category": "minspawn"},
	
	"spawnmas": {"name": "Spawn Master", "on_cast": "place_unit_at_cursor", "cast_args": ["master"], "category": "minspawn"},
	
	"spawnagent": {"name": "Spawn Agent", "on_cast": "place_unit_at_cursor", "cast_args": ["agent"], "category": "minspawn"},
	"spawnguard": {"name": "Spawn Guard", "on_cast": "place_unit_at_cursor", "cast_args": ["guard"], "category": "minspawn"},
	"spawngunn": {"name": "Spawn Gunner", "on_cast": "place_unit_at_cursor", "cast_args": ["machinegunner"], "category": "minspawn"},
	"spawnboxer": {"name": "Spawn Boxer", "on_cast": "place_unit_at_cursor", "cast_args": ["boxer"], "category": "minspawn"},
	"spawnore": {"name": "Spawn Ore", "on_cast": "place_item_at_cursor", "cast_args": ["ore"], "category": "itemspawn"},
	
	"nines": {"name": "Little #9s", "on_cast": "i_can_make_little_number_nines_appear", "cast_args": [], "category": "spells"},
	
	
	"digfill": {"icon": "sampleicon", "name": "Dig/Fill", "on_cast": "flip_dragged", "dragselect": true, "category": "interface"},
	
	"makeidle": {"name": "Meeting Zone", "on_prime": "scan_squares", "on_cast": "make_zone_from_dragbox", "cast_args": ["idle"], "category": "zones", "dragselect": true, "targeting": "SQUARE"},
	"makepatrol": {"name": "Patrol Node", "on_prime": "scan_squares", "on_cast": "make_waypoint_at_highlight", "cast_args": ["patrol"], "category": "waypoints", "targeting": "SQUARE", "panel": "waypointplacement"},
	
	"inspire": {"name": "Inspire", "on_prime": "make_aoe", "prime_args": ["cone", 128], "on_cast": "buff_aoe", "cast_args": ["inspired"], "category": "spells", "targeting": "UNIT"},
	
	"blast": {"name": "Hunger Blast", "on_prime": "make_aoe", "prime_args": ["cone", 128], "on_cast": "drain_aoe", "cast_args": ["food", -9], "category": "spells", "targeting": "UNIT"},
	
}

var builddata = JobData.new(
		{
		"action": "build_furniture",
		"args": [],
		"speed": 1.0,
		"requirements": {},
		"type": "build",
		"drains": {},
		"slots": {"interact": {"count": 1, "role": "builder"}},
		"rules": rules,
		"desired_role": "builder"}
		)
var sabodata = JobData.new(
	{
		"action": "sabotage_furniture",
		"args": [],
		"speed": 1.0,
		"requirements": {},
		"type": "build",
		"drains": {},
		"slots": {"interact": {"count": 1, "role": "builder"}},
		"rules": rules,
		"desired_role": "saboteur"}
)

var spydata = JobData.new(
	{
		"action": "spy_on_furniture",
		"args": [],
		"speed": 1.0,
		"requirements": {},
		"type": "interact",
		"drains": {},
		"slots": {"interact": {"count": 1, "role": "builder"}},
		"rules": rules,
		"desired_role": "saboteur"}
)

var jobs_to_load = {
	
	"exfiltrate": {
		"name": "exfiltrate actors",
		"action": "exfiltrate_actors",
		"instant": true,
		"args": [],
		"speed": 1,
		"requirements": {},
		"type": "interact",
		"slots": {
			"interact": {
				"count": 1, "role": "worker", "reserving": false
				}},
		"drains": {},
		
	},
	
	"imprison": {
		"name": "imprison unit",
		"action": "imprison_actor",
		"args": ["interact"], 
		"speed": 0.1,
		"requirements": {},
		"type": "interact",
		"slots": {
			
			#ESCORTER gets a task to go to the ESCORTED, then ESCORTER carries ESCORTED to the job spot
			"interact": {
				"count": 1, "role": "worker", "reserving": false, "escorted": true, "escortrole": "worker",
			},
		},
		"drains": {},
	},
	
	"cameradesk": {
		"name": "Monitor Cameras",
		"action": "try_continue",
		"on_start": "start_monitor_camera_network",
		"on_pause": "pause_monitor_camera_network",
		"args": [200],
		"start_args": [200],
		"pause_args": [200],
		"speed": 1000000,
		"indefinite": true,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 1},
		
		},
	
	#***Research Jobs
	"microscope": {
		"name": "microscope research",
		"action": "perform_research",
		"args": ["microscope", 1], 
		"speed": 10,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 1},
		},
		
	"computer": {
		"name": "computer research",
		"action": "perform_research",
		"args": ["computer research", 1], 
		"speed": 10,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 1},
		},
	
	
	
	#***Restoration Jobs
	
	"getpaste": {
			"name": "get mealpaste",
			#"continues": true,
			"instant": true,
			"action": "get_food",
			"args": ["eatpaste"],
			"speed": 1,
			"requirements": {},
			"type": "restore",
			"slots": {"interact": {"count": 1, "role": "worker"}},
			"drains": {}
		},
		
	"eatpaste": {
			"name": "eat mealpaste",
			"action": "finish_eating",
			"args": ["mealpaste"],
			"speed": 500,
			"requirements": {},
			"type": "restore",
			"slots": {"interact": {"count": 1, "role": "anybody"}},
			"drains": {"food": -3},
		},
	
	"clinic": {
		"name": "clinic healing",
		"action": "dummy",
		"args": ["health", 1],
		"speed": 1000000,
		"requirements": {},
		"type": "restore",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"health": -3},
		},
	
	"heal": {
		"name": "healthkit",
		"action": "dummy",
		"args": ["health", 1],
		"speed": 1000000,
		"requirements": {},
		"type": "restore",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"health": -3},
		},
		
		
		
	"gobed": {
		"name": "single sleep",
		"action": "get_in_bed",
		"args": [],
		"speed": 1,
		"continues": true,
		"requirements": {},
		"type": "restore",
		"instant": true,
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {},
		},
	"sleep": {
		"name": "sleeping",
		"action": "finish_sleeping",
		"args": [],
		"speed": 1000000,
		"personal": true,
		"requirements": {},
		"type": "restore",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": -3},
		},
	"passout": {
		"name": "sleeping",
		"action": "finish_sleeping",
		"args": [],
		"speed": 1000000,
		"personal": true,
		"in_place": true,
		"requirements": {},
		"type": "restore",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": -1, "loyalty": 0.2},
		},
	
	
	#***Production Jobs
	
	"getcash": {
		"name": "Produce Cash",
		"action": "change_resource",
		"args": ["cash", 1], 
		"speed": 10,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 1},
		},
	"cashsmelt": {
		"name": "Smelt Metal From Ore",
		"action": "make_resource",
		"args": ["metal", 10],
		"speed": 1,
		"requirements": {"ore": 3},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 5},
		},
	
	
		
	
	
	"smithpopper": {
		"name": "Smith Popper Pistol",
		"action": "make_resource",
		"args": ["popper", 1],
		"speed": 1,
		"requirements": {"metal": 1},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 3},
		},
		
	"smithstudder": {
		"name": "Smith Studder SMG",
		"action": "make_resource",
		"args": ["studder", 1],
		"speed": 1,
		"requirements": {"metal": 2},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 3},
		},
	
	#Format: Modifiers: Modtype: Modvalue: Percentaffected
	"mine": {
		"name": "Mine Ore",
		"action": "make_resource",
		"args": ["metal", 1],
		"speed": 1,
		"experience": {"interact": {"work": 0.5}},
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker", 
			"modifiers": {
					"haste": {
						#100% of strengthspeed modifier is applied to both Work and Drains, so 10 strengthspeed means a 10% increase in haste
						"strengthspeed": 100,
						"globalworkspeed": 100
					},
					"efficiency": {
						"miningefficiency": 100,
						"globalworkefficiency": 100
					}
				},
			}
		},
		"drains": {"energy": 3},
		"skilltrains": {"machines": 1},
		},
		
	
		
	"makebasicacid": {
		"name": "Synthesize Natural Acid",
		"action": "make_resource",
		"args": ["acid", 1],
		"speed": 1,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"efficiency": {
			"globalworkefficiency": 100
		},
		"drains": {"energy": 3},
		},
		
	#***Power Jobs
		
	"oilgenerator": {
		"name": "Oil Power",
		"action": "continue_fueled_power",
		"args": [10],
		"speed": 10,
		"requirements": {"ore": 1},
		"type": "interact",
		"slots": {},
		"drains": {},
		"repeating": true,
		"automatic": true,
		"on_start": "start_fueled_power"
		},
		
	#***Command Jobs
		
	"scan": {
		"name": "Scan for Opportunities",
		"action": "scan_amount",
		"args": [1], "speed": 1,
		"requirements": {},
		"certs": {"interact": ["scancert"]},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 3},
		},
	
	
	
	
	
		
	#***Item Jobs
	
	"usestim": {
			"name": "use stimpack",
			"action": "apply_buff",
			"args": ["stimpack"],
			"speed": 0.5,
			"requirements": {"stimpack": 1},
			"type": "consume",
			"slots": {"interact": {"count": 1, "role": "worker"}},
			"drains": {},
		},
		
		
	#***Dummy Jobs
	
	"vault": {
		"name": "vaultdummy",
		"action": "dummy",
		"args": [],
		"speed": 1,
		"requirements": {},
		"type": "grab",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {},
		},
		
	#***Debug Jobs
	
	"tired": {
		"name": "debugmaketired",
		"action": "hurtdummy",
		"args": [],
		"speed": 100000,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 1},
		},
	
	"superlongtask": {
		"name": "Super Longtask",
		"action": "make_resource",
		"args": ["ore", 1],
		"speed": 10,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": 3},
		},
	
	"freegenerator": {
		"name": "Free Power",
		"action": "continue_fueled_power",
		"args": [10],
		"speed": 10,
		"requirements": {},
		"type": "interact",
		"slots": {},
		"drains": {},
		"repeating": true,
		"automatic": true,
		"on_start": "start_fueled_power"
		},
	
	"gigapain": {
		"name": "healthhurt",
		"action": "hurtdummy",
		"args": ["health", -1],
		"speed": 1000000,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"health": 1},
		},
	"starve": {
		"name": "starve",
		"action": "hurtdummy",
		"args": ["food", -1],
		"speed": 3,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"food": 1},
	},
	"hurtntired": {
		"name": "hurtntired",
		"action": "hurtdummy",
		"args": [],
		"speed": 1000000,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains":  {"energy": 1, "health": 1},
		},
		
	"twotasks": {
		"name": "Two Tasks",
		"service": true,
		"action": "make_resource",
		"args": ["ore", 1],
		"speed": 1,
		"requirements": {},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}, "serve": {"count": 1, "role": "worker"}},
		"drains": {"energy": 2},
		},
		
	"bossdesk": {
		"name": "Sit and Scheme",
		"action": "finish_sitting",
		"args": [],
		"speed": 1000000,
		"personal": true,
		"requirements": {},
		"type": "restore",
		"slots": {"interact": {"count": 1, "role": "worker"}},
		"drains": {"energy": -3},
	},
		
	"entertain": {
		"name": "Two Tasks",
		"service": true,
		"action": "finish_restore",
		"args": [],
		"speed": 1000000,
		"requirements": {},
		"certs": {"interact": ["mastercert"]},
		"type": "interact",
		"slots": {"interact": {"count": 1, "role": "worker"}, "serve": {"count": 1, "role": "worker"}},
		"drains": {"loyalty": -2},
		},
	
	
}

#special shop entries that give a quest
var schemes = {
	"valuabletheft": {
		"quest": "domission",
		"prices": {
			"cash": 100
		},
	}
}

var doomsday_to_load = {
	"supergun": {
		"quests": {
			#Quests that must be finished before completion sequence
			1: ["longquest"]
		},
		"furniture": {
			1: ["supersilo"]
		},
		#schemes unlocked with each Phase
		"schemes": {
			1: []
		}
	}
}

var quests_to_load = {
	"longquest": {
		"name": "Spend Some Cash",
		"rewards": [
			{
				"type": "CashReward",
				"args": {
					"amount": 10000
				},
			}
		],
		"steps": 
			[
				{	"name": "Step One",
					"rewards": [
						{
							"type": "CashReward",
							"args": {
								"amount": 10000
							},
						}
					],
					"objectives": [
					{"type": "ResourceSpendObjective",
					"args": {
						"amount": 300,
						"resource": "cash"
					}}
				]},
				{	"name": "Step One",
					"objectives": [
					{"type": "ResourceObjective",
					"args": {
						"amount": 300,
						"resource": "influence"
					}}
				]},
				{
				"name": "Step One",
				"objectives": [
					{"type": "EncounterObjective",
					"args": {
						"enc": "skirmish"
					}}
				]},
				{
				"name": "Step One",
				"objectives": [
					{"type": "WaveObjective",
					"args": {
						"enc": "scoutwave"
					}}
				]},
				]
	},
	"havecash": {
		"name": "Spend Some Cash",
		"rewards": [
			{
				"type": "CashReward",
				"args": {
					"amount": 10000
				},
			}
		],
		"steps": 
			[
				{	"name": "Step One",
					"objectives": [
					{"type": "ResourceSpendObjective",
					"args": {
						"amount": 300,
						"resource": "cash"
					}}
				]}
			]
	},
	"sendstuff": {
		"name": "Send Some Stuff",
		"steps": 
			[
				{	"name": "Step One",
					"objectives": [
					{"type": "ItemSendObjective",
					"args": {
						"amount": 3,
						"item": "ore"
					}}
				]}
			]
	},
	"haveinf": {
		"name": "Have Some Influence",
		"steps": 
			[
				{	"name": "Step One",
					"objectives": [
					{"type": "ResourceObjective",
					"args": {
						"amount": 300,
						"resource": "influence"
					}}
				]}
			]
	},
	"domission": {
		"name": "Do an Encounter",
		"steps": [
			{
				"name": "Step One",
				"objectives": [
					{"type": "EncounterObjective",
					"args": {
						"enc": "skirmish"
					}}
				],
				"rewards": [
					{
						"type": "ItemReward",
						"args": {
							"item": "metal",
							"amount": 50,
						},
					}
				],
			}
		]
	},
	"killwave": {
		"name": "Kill a Wave",
		"steps": [
			{
				"name": "Step One",
				"objectives": [
					{"type": "WaveObjective",
					"args": {
						"enc": "scoutwave"
					}}
				]
			}
		]
	}
}

var blocks_to_load = {
	"grass" : {"datakey": "grass", "type": "floor", "name": "Grass", "sprite": "grass", "movemod": 0.75},
	"dirt": {"datakey": "dirt","type": "floor", "name": "Dirt", "sprite": "grass", "movemod": 0.75},
	"rock": {"datakey": "rock","type": "wall", "name": "Rock", "sprite": "rock"},
	"wall": {"datakey": "wall","type": "wall", "name": "Wall", "sprite": "wall"},
	"tile": {"datakey": "tile","type": "floor", "name": "Tile", "sprite": "grass", "movemod": 1.00},
	"water": {"datakey": "water","type": "edge", "name": "Water", "sprite": "water"},
	"border": {"datakey": "border","type": "edge", "name": "Border", "sprite": "water"}
}

var furniture_to_load = {
	
	"arcadecabinet": {
		"jobs": ["entertain"],
		"spots": {"interact": [{"pos": 0, "side": 0}], "serve": [{"pos": 0, "side": 2}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"power": 3,
		"object_name": "Entertainer",
		"spritepath":"moneymachine",
		"type": "machine",
		"category": "healers",
		"tags": ["loyalty"],
	},
	
	"safecapsule": {
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Mostly Safe Capsule",
		"lifepod": true,
		"spritepath":"healthbox",
		"type": "machine",
		"category": "furniture",
		"tags": ["lifepod"],
	},
	
	"prisoncell": {
		"jobs": ["imprison"],
		"prison": true,
		"spyheat": 10,
		
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Prison Cell",
		"spritepath":"healthbox",
		"type": "prison",
		"category": "furniture",
		"tags": ["computer"],
	},
	
	#***Security
	"camera": {
		"size": {"x": 1, "y": 1},
		"manual": false,
		"collision": false,
		"wallmount": true,
		"object_name": "Security Camera",
		"spritepath": "panel",
		"type": "camera",
		"camera": {
			"perception": 10
		},
		"spotters": [
			{
				"type": "footprint"
			}
		],
		"category": "cameras",
		"tags": ["camera"],
	},
	
	"cameradesk": {
		"jobs": ["cameradesk"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Camera Desk",
		"spritepath": "panel",
		"type": "machine",
		"category": "furniture",
		"tags": ["security"],
	},
	
	"spiketrap": {
		"size": {"x": 1, "y": 1},
		"manual": false,
		"collision": false,
		"object_name": "Spike Trap",
		"spritepath": "gunsmith",
		"type": "trap",
		"trap": {
			"triggers": {
				"on_trapping": 
					[
						
					]
			}
		},
		"spotters": [
			{
				"type": "footprint"
			}
		],
		"category": "traps",
		"tags": ["camera"],
	},
	
	#***
	#Laboratory
	#***
	
	"computer": {
		"jobs": ["computer"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Lab Terminal",
		"spritepath":"healthbox",
		"type": "machine",
		"category": "furniture",
		"tags": ["computer"],
	},
	
	"microscope": {
		"jobs": ["microscope"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Microscope",
		"spritepath":"healthbox",
		"type": "machine",
		"category": "furniture",
		"tags": ["microscope"],
	},
	
	
	
	
	
	"pastemachine": {
		"jobs": ["eatpaste"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Paste Machine",
		"spritepath":"healthbox",
		"type": "machine",
		"category": "healers",
		"tags": ["food"],
	},
	
	"table": {
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Meal Table",
		"spritepath":"healthbox",
		"type": "accessory",
		"category": "healers",
		"tags": ["table"]
	},
	
	"firstaid": {
		"jobs": ["heal"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Healer",
		"spritepath":"healthbox",
		"type": "machine",
		"category": "healers",
		"tags": ["health"]},
	
	"smelter": {
		"jobs": ["cashsmelt"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Smelter",
		"spritepath": "metalmaker",
		"type": "machine",
		"category": "furniture",
		"power": 3
		},
		
	"door": {
		"type": "door",
		"spritepath": "caution",
		"object_name": "Door",
		"collision": false,
		"size": {"x": 1, "y": 1},
		"category": "doors"
	},
		
	"mine": {
		"jobs": ["mine"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Mine",
		"spritepath": "mine",
		"type": "machine",
		"category": "furniture",},
		
	"twotask": {
		"jobs": ["twotasks"],
		"spots": {"interact": [{"pos": 0, "side": 0}], "serve": [{"pos": 0, "side": 2}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Two Tasks",
		"spritepath": "moneymachine",
		"type": "machine",
		"category": "furniture",},
		
	"vat": {
		"jobs": ["makebasicacid"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Chemical Vat",
		"spritepath": "metalmaker",
		"type": "machine",
		"category": "furniture",
		"power": 1},
		
	"punchingbag": {
		"jobs": [],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Punching Bag",
		"spritepath": "metalmaker",
		"type": "machine",
		"category": "furniture",
		"teaches": ["physicalbasic"]
	},
	
	"superlongtaskbox": {
		"jobs": ["superlongtask"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Superlong Taskbox",
		"spritepath": "gunsmith",
		"type": "machine",
		"category": "furniture",
	},
		
	"gunsmith": {
		"jobs": ["smithpopper", "smithstudder"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Gunsmith's Bench",
		"spritepath": "gunsmith",
		"type": "machine",
		"category": "furniture",
	},
	
	"scanpanel": {
		"jobs": ["scan"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Scanner",
		"spritepath": "panel",
		"type": "machine",
		"category": "furniture",
		"tags": ["command"]},
	
	"bed": {
		"jobs": ["sleep"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Bed",
		"spritepath": "metalmaker",
		"type": "machine",
		"category": "healers",
		"tags": ["energy"]
		},
	
	"bigthing": {
		"jobs": ["getcash"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 2, "y": 2},
		"object_name": "Big Thing",
		"spritepath": "xtrabig",
		"type": "machine",
		"category": "furniture",
		},
	
	"depot": {
		"jobs": ["vault"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 2, "y": 2},
		"object_name": "Depot",
		"spritepath": "depot",
		"type": "depot",
		"category": "containers",
		"depot": true,
		"shelves": [
			{"name": "storage", "whitelist": []},
			{"name": "sell", "whitelist": []},
			{"name": "quest", "whitelist": []},
			{"name": "theft", "whitelist": []},
			]
		},
		
	"patrol": {
		"jobs": [],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"manual": false,
		"object_name": "Patrol Node",
		"spritepath": "waypoint",
		"type": "patrol",
		"collision": false,
		"category": "furniture",
		"tags": ["patrolnode"],
		"needs_build": false
	},
		
	"heliport": {
		"jobs": ["exfiltrate"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 2, "y": 2},
		"object_name": "Heliport",
		"spritepath": "heliport",
		"type": "port",
		"category": "infrastructure",
		"depot": true,
		"shelves": [{"name": "storage", "whitelist": ["thang"]}]},
	
	"big2": {
		"jobs": ["getcash"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 2, "y": 2},
		"object_name": "Big Thing 2",
		"spritepath": "furnituregeneric",
		"type": "machine",
		"category": "furniture",},
	
	"crate": {
		"jobs": ["vault"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Crate",
		"spritepath": "vault",
		"type": "container",
		"category": "containers",
		"shelves": [{"name": "storage", "whitelist": ["thang"]}]
		},
	"oilgenerator":  {
		"jobs": ["oilgenerator"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		"size": {"x": 1, "y": 1},
		"object_name": "Oil Generator",
		"spritepath": "metalmaker",
		"type": "machine",
		"category": "furniture",
		"tags": ["power"]
		},
	"freegenerator":  {
		"jobs": ["freegenerator"],
		"spots": {"interact": [{"pos": 0, "side": 0}]},
		
		"spyheat": 10,
		
		"size": {"x": 1, "y": 1},
		"object_name": "Free Generator",
		"spritepath": "metalmaker",
		"type": "machine",
		"category": "furniture",
		"tags": ["power"]
		},
	}
	
var roles = ["worker", "hauler", "builder", "guard"]

var defaultclass = UnitClass.new({
		"name": "minion",
		"roles": {}
	})
	
	
	
	
	
	
var spells = {
	"testcast": {
		#"type": "active",
		"cooldown": 1,
		"attention_cost": 2,
		#"everyframe": true,
		"fire_action": "change_target_unit_stat",
		"target_function": "get_targeter",
		"fire_args": ["health", 10],
		"automatic": true,
		"conditions": [
			{
				"type": "StatCondition",
				"statname": "health",
				"stattype": "fuels",
				"direction": "lesser",
				"by_parent": true,
				"target": "by",
				"desired_percent": 50,
				"desired_flat": 20
			}
		]
	}
}
	
	
	
	
#***************************************************************************
#*********************************ABILITIES*********************************
#***************************************************************************
	
var abilities_to_load = {
	
	#********STAT-RELATED ABILITIES
	#*****LOYALTY EFFECTS
	"waveringloyalty": {
		"type": "passive",
		"effects": {
			"breakchance": 10,
			"defectchance": 25,
			"slackchance": 20,
			"globalworkhaste": -10,
		}
		
	},
	
	"armorbuster": {
		"type": "passive",
		"effects": {
			"armorbuster": 1
		}
	},
	
	"badloyalty": {
		"type": "passive",
		"effects": {
			
		}
	},
	
	"goodloyalty": {
		"type": "passive",
		"effects": {
			"globalworkefficiency": 1,
		}
	},
	
	"highloyalty": {
		"type": "passive",
		"effects": {
			
		}
	},
	
	
	
	
	
	
	
	
	
	#*****TEST ABILITIES
	
	"strengthbonus": {
		"type": "passive",
		"effects": {
			"melee_power": 10
		}
	},
	
	"basicgunnerybonus": {
		"type": "passive",
		"effects": {
			"shooting_accuracy": 10
		}
		
	},
	
	"testtrigger": {
		"type": "passive",
		"effects": {
			"triggertest": 1
		},
		
		
		"conditions": [
			{
				"type": "StatCondition",
				"statname": "health",
				"stattype": "fuels",
				"direction": "lesser",
				"by_parent": true,
				"target": "by",
				"desired": 50,
			}
		]
	},
	"basicboxingbonus": {
		"type": "passive",
		"effects": {
			"health_max": 5,
			"fist_damage": 5,
			"fist_accuracy": 10
		},
		"conditions": [
			{
				"type": "StatCondition",
				"statname": "health",
				"stattype": "fuels",
				"direction": "lesser",
				"by_parent": true,
				"target": "by",
				"desired": 50,
			}
		],
		
	},
	"learningstrengthbonus": {
		"type": "passive",
		"effects": {
			"strengthbonus": 1
		},
	},
	"lessoncapbonus": {
		"type": "passive",
		"effects": {
			"lessoncapbonus": 1
		},
	},
	"scancert": {
		"type": "passive",
		"effects": {
			"scancert": 1
		},
	},
	"masteraura": {
		"type": "passive",
		"effects": {
			"masteraura": 1,
			"mastercert": 1
		}
	},
	"nightshadepoison": {
		"type": "passive",
		"triggers": {
			"damage_rolled": [
				{
					"action": "grant_status_buildup",
					"conditions": [
						{
							"type": "MeleeAttackCondition",
							"value": true,
							"by_parent": false,
						}
					],
					"includes": true,
					"args": ["poison", 10],
				}
			]
		},
	},
}

var effects_to_load = {
	"triggertest": {
		"type": "mod",
		"triggers": {
			"damage_rolled": [
				{
					"action": "percent_bonus_to_damage_total",
					"conditions": [
						{
							"type": "StatCondition",
							"statname": "health",
							"stattype": "fuels",
							"direction": "greater",
							"by_parent": true,
							"target": "by",
							"desired": 90,
						}
					],
					"includes": true,
					"args": ["burn", "health", 100],
				}
			]
		},
	},
	"claws": {
		"type": "attack",
		"weapon": "claw"
	},
	"scales": {
		"type": "armor",
		"armor": "scales"
	},
	"masteraura": {
		"type": "aura",
		"auradata": {
			"radius": 256,
			"collides": true,
		},
		"applied_effects": {
				"master": 1
		}
	},
	"master": {
		"type": "mod",
		"modifiers": {
			"haste": 30
		}
	},
	"poison": {
		"type": "overtime",
		"damage": {
			"stat": "health",
			"amount": 2
		}
	},
	"phantom": {
		"type": "overtime",
		"damage": {
			"stat": "health",
			"amount": -1
		}
	},
	"shooting_accuracy": {
		"type": "mod",
		"modifiers": {
			"shooting_accuracy": 10,
			"shooting_damage": 10
		}
	},
	
	
	
	#*****CONDITIONAL ABILITIES
	"armorbuster": {
		"type": "mod",
		"triggers": {
			"damage_rolled": [
				{
					"action": "constant_ap_bonus_to_damage_total",
					"conditions": [
						{
							"type": "AttackDistanceCondition",
							"direction": "lesser",
							#"by_parent": true,
							"target": "by",
							"desired": 90,
						}
					],
					"includes": true,
					"args": [100],
				}
			]
		},
	},
	
	

}

var buffs_to_load = {
	"inspired": {
		"name": "Inspiration",
		"duration": 10,
		"effects": {
			"master": 1
		}
	},
	"poison": {
		"name": "Poison",
		"duration": 10,
		"effects": {
			"poison": 1
		},
		"stacking": false,
	},
	"phantom": {
		"name": "Poison",
		"duration": 10,
		"effects": {
			"phantom": 1
		},
		#"stacking": true,
	},
	"armorstrip": {
		"duration": 1,
		"effects": {
			"poison": 1
		}
	}
}
	
var upgrades_to_load = {
	
	"sadist": {
		"name": "Sadist Trait",
		"article":
			{"title": "Sadist Trait", "body": "Unit gains Loyalty when dealing damage."},
		"time": 1,
		"type": "trait",
		"limit": "trait",
		"cost": {"ore": 1},
		"abilities": {
			"learningstrengthbonus": 5
		},
		"taught_by": "physicalbasic"
	},
	
	"strengthenhancements": {
		"name": "Strength Training",
		"article":
			{"title": "Strength Enhancements", "body": "Increases the unit's Strength Quality by 5."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"cost": {"ore": 1},
		"abilities": {
			"learningstrengthbonus": 5
		},
		"taught_by": "physicalbasic"
	},
	
	"scancert": {
		"name": "Strength Training",
		"article":
			{"title": "Scanning Certification", "body": "Unit can operate Scanning furniture."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"cost": {"ore": 1},
		"abilities": {
			"scancert": 1
		},
		"taught_by": "physicalbasic"
	},
	
	"handgun": {
		"name": "Hand Gun",
		"article":
			{"title": "Hand Gun", "body": "Unit has a gun in their hand."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"cost": {"metal": 1},
		"abilities": {
			"pistolability": 1
		},
		"taught_by": "physicalbasic"
	},
	
	"tigerjaw": {
		"name": "Tiger Jaw",
		"article":
			{"title": "Tiger Jaw", "body": "A martial arts technique."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"cost": {"metal": 1},
		"abilities": {
			"tigerjawability": 1
		},
		"taught_by": "physicalbasic"
	},
	
	"phantomstrike": {
		"name": "Tiger Jaw",
		"article":
			{"title": "Tiger Jaw", "body": "A martial arts technique."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"cost": {"metal": 1},
		"abilities": {
			"phantomstrikeability": 1
		},
		"taught_by": "physicalbasic"
	},
	
	"triggertest": {
		"name": "Trigger Test",
		"article":
			{"title": "Strength Enhancements", "body": "Increases the unit's Strength Quality by 5."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"cost": {"ore": 1},
		"abilities": {
			"testtrigger": 5
		},
		"taught_by": "physicalbasic"
	},
	
	"testcast": {
		"name": "Casting Test",
		"article":
			{"title": "Strength Enhancements", "body": "Increases the unit's Strength Quality by 5."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"cost": {"ore": 1},
		"abilities": {
			"testcastability": 1
		},
		"taught_by": "physicalbasic"
	},
	"goonbonus": {
		"name": "Gunnery Basics",
		"article":
			{"title": "Goon's Instincts", "body": "Increases the unit's Lesson Cap by 1."},
		"time": 1,
		"type": "upgrade",
		"limit": "unlimited",
		"abilities": {"lessoncapbonus": 1},
		"taught_by": "physicalbasic"
	},
	"shootingbasics": {
		"name": "Gunnery Basics",
		"article":
			{"title": "Strength Training", "body": "Increases the unit's Strength Quality by 5."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"abilities": {"basicgunnerybonus": 1},
		"taught_by": "physicalbasic"
	},
	"shootingsuper": {
		"name": "Gunnery Basics",
		"article":
			{"title": "Strength Training", "body": "Increases the unit's Strength Quality by 5."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"abilities": {"gunnerydamagebonus": 1},
		"taught_by": "physicalbasic"
	},
	"punchingbasics": {
		"name": "Punching Basics",
		"article":
			{"title": "Strength Training", "body": "Increases the unit's Strength Quality by 5."},
		"time": 1,
		"limit": "lesson",
		"type": "upgrade",
		"abilities": {
			"basicboxingbonus": 1
		},
		"taught_by": "physicalbasic"
	},
	"strengthtraining": {
		"name": "Strength Training",
		"article":
			{"title": "Strength Training", "body": "Increases the unit's Strength Quality by 5."},
		"time": 1,
		"limit": "lesson",
		"type": "upgrade",
		"abilities": {
			"learningstrengthbonus": 5
		},
		"taught_by": "physicalbasic"
	},
	
	#POWERS
	"clawgments": {
		"name": "Clawgments",
		"article":
			{"title": "Clawgments", "body": "Gives you some pretty cool claws."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"itemcost": {"metal": 1},
		#"item_per_scaling": {"ore": 1},
		"manacost": {"cash": 100},
		"mana_per_scaling": {"cash": 10},
		#"time_per_scaling": 50,
		"abilities": {
			"clawability": 5
		},
		"taught_by": "physicalbasic"
	},
	"reflector": {
		"name": "Reflector",
		"article":
			{"title": "Reflector", "body": "Reflects 10% of damage back at attackers."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"itemcost": {"metal": 1},
		#"item_per_scaling": {"ore": 1},
		"manacost": {"cash": 100},
		"mana_per_scaling": {"cash": 10},
		#"time_per_scaling": 50,
		"abilities": {
			"damagereflect": 10
		},
		"taught_by": "physicalbasic"
	},
	"armorbuster": {
		"name": "Armor Buster",
		"article":
			{"title": "Armor Buster", "body": "Grants increased AP at close range."},
		"time": 1,
		"type": "upgrade",
		"limit": "lesson",
		"itemcost": {"metal": 1},
		#"item_per_scaling": {"ore": 1},
		"manacost": {"cash": 100},
		"mana_per_scaling": {"cash": 10},
		#"time_per_scaling": 50,
		"abilities": {
			"armorbuster": 1
		},
		"taught_by": "physicalbasic"
	},
	
}



var origins_to_load = {
	"goon": {
		"name": "goon",
		"selectable": true,
		"roles": {},
		"lessons": [
			"goonbonus",
		],
	},
	"nightshade": {
		"name": "nightshade",
		"selectable": true,
		"roles": {},
		"lessons": [
			"goonbonus",
		],
	}
}
	
var classes_to_load = {
	"minion":{
		"name": "minion",
		"roles": {"hauler": 1, "worker": 1, "builder": 1}
	},
	"guard": {
		"name": "guard",
		"selectable": true,
		"roles": {"guard": 1},
		"lessons": [
			"shootingbasics", "punchingbasics", "armorbuster"
		],
		"equipment": {
			"weapon": {"popper": 2, "studder": 3, "rifle": 2, "sword": 2},
			"head": {"gasmask": 2},
			"armor": {"flakjacket": 2},
		},
		"aggro": true
	},
	
	"clawboy": {
		"name": "clawboy",
		"selectable": true,
		"roles": {"guard": 1, "hauler": 1},
		"lessons": [
			"shootingbasics", "punchingbasics", "clawgments"
		],
		"equipment": {
			"weapon": null,
			"head": null,
			"armor": {"flakjacket": 2},
		},
		"aggro": true
	},
	
	"agent": {
		"name": "agent",
		"class": "agent",
		"selectable": true,
		"roles": {"guard": 1},
		"lessons": ["armorbuster"],
		"equipment": {
			"weapon": {"popper": 2, "studder": 3, "rifle": 2},
			"armor": {"flakjacket": 1},
			"head": null,
		},
		"aggro": true
	},
	
	
	"master": {
		"name": "master",
		"roles": {"master": 1},
		"lessons": [
		],
		"equipment": {
			
		},
		"aggro": true
	}
}
	
var units_to_load = {
	
	"lottastuffguy": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		"roles": ["guard"],
		"class": "guard",
		"lessons": ["testcast", "punchingbasics", "shootingbasics", "strengthtraining", "clawgments", "triggertest", "strengthenhancements"],
		"starter_equipment": {
			"weapon": "popper",
			"armor": "flakjacket",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		
		
		
		},
	
	"master": {
		"allegiance": "player",
		"aggressive": false,
		"sprite": "minion",
		"roles": ["master"],
		"class": "master",
		"abilities": ["masteraura"],
		"lessons": [],
		"master": true,
		"starter_equipment": {
			"weapon": null,
			"armor": null,
			"head": "bighat",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	
	"minion": {
		"allegiance": "player",
		"aggressive": false,
		"sprite": "minion",
		"roles": ["worker", "hauler", "builder"],
		"starter_equipment": {
			"weapon": null,
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"intern": {
		"allegiance": "player",
		"aggressive": false,
		"sprite": "minion",
		"roles": ["worker", "hauler", "builder"],
		"lessons": ["scancert"],
		"starter_equipment": {
			"weapon": null,
			"armor": "gasmask",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"beefcake": {
		"allegiance": "player",
		"aggressive": false,
		"sprite": "minion",
		"roles": ["worker", "hauler", "builder"],
		"stats": {
			"qualities": {
				"strength": 200
			}
		},
		"starter_equipment": {
			"weapon": null,
			"armor": "flakjacket",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
	},
	"guard": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		"roles": ["guard"],
		"class": "guard",
		"lessons": [],
		"starter_equipment": {
			"weapon": "popper",
			"armor": "flakjacket",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
	},
	"twogunterry": {
		"allegiance": "coalition",
		"aggressive": true,
		"sprite": "minion",
		"roles": ["guard"],
		#"class": "guard",
		"lessons": ["handgun"],
		"starter_equipment": {
			"weapon": "popper",
			"armor": "flakjacket",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
	},
	"clawboy": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		"roles": ["guard"],
		"class": "clawboy",
		"lessons": ["clawgments"],
		"starter_equipment": {
			"weapon": null,
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"casterguard": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		"roles": ["guard"],
		"class": "guard",
		"lessons": ["testcast"],
		"starter_equipment": {
			"weapon": "popper",
			"armor": "flakjacket",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"agent": {
		"allegiance": "coalition",
		"aggressive": true,
		"sprite": "minion",
		"roles": ["agent"],
		#"lessons": ["armorbuster"],
		"class": "agent",
		"starter_equipment": {
			"weapon": null,
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		
		#The min stats set when generated by wizard
		"stat_min": {
			
		},
		#The max stat bonus this unit's wizard can roll
		"stat_max": {
			
		},
		#Weighting for how stat points are assigned
		"stat_weights": {
			
		},
		#The minimum & maximum amount of stat points the unit gets when generated
		"min_bonus": 10,
		"max_bonus": 20,
		
		"equipment_options": {
			"weapon": ["popper", "studder"]
		},
		
		"upgrade_options": {
			"slot1": ["punchingbasics", "shootingbasics", "armorbuster"]
		},
		"upgrade_max": {
			"slot1": 3
		}
		
		},
		
	"flakboy": {
		"allegiance": "coalition",
		"aggressive": true,
		"sprite": "minion",
		"roles": ["agent"],
		"class": "agent",
		"starter_equipment": {
			"weapon": null,
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		
		"equipment_options": {
			"weapon": ["popper", "studder"],
			"armor": ["flakjacket"]
		},
		
		"upgrade_options": {
			"slot1": ["punchingbasics", "shootingbasics", "strengthtraining", "clawgments"]
		},
		"upgrade_max": {
			"slot1": 3
		}
		
		},
		
	"spicyagent": {
		"allegiance": "coalition",
		"aggressive": true,
		"sprite": "minion",
		"roles": ["agent"],
		"class": "agent",
		"lessons": ["triggertest"],
		"starter_equipment": {
			"weapon": "popper",
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"generalissue": {
		"allegiance": "coalition",
		"aggressive": true,
		"sprite": "minion",
		"class": "agent",
		"roles": ["agent"],
		"starter_equipment": {
			"weapon": "studder",
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"machinegunner": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		"class": "guard",
		"roles": ["guard"],
		"starter_equipment": {
			"weapon": "studder",
			"armor": "flakjacket",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"rifleguard": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		"class": "guard",
		"roles": ["guard"],
		"starter_equipment": {
			"weapon": "rifle",
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"rifleman": {
		"allegiance": "coalition",
		"aggressive": true,
		"sprite": "minion",
		"class": "agent",
		"roles": ["agent"],
		"starter_equipment": {
			"weapon": "rifle",
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
		},
	"laserman": {
		"allegiance": "coalition",
		"aggressive": true,
		"sprite": "minion",
		"class": "agent",
		"roles": ["agent"],
		"starter_equipment": {
			"weapon": "raygun",
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
	},
	"mrtiger": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		#"class": "agent",
		"lessons": ["tigerjaw"],
		"roles": ["agent"],
		"starter_equipment": {
			"weapon": null,
			"armor": "justicejacket",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
	},
	"mrphantom": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		#"class": "agent",
		"lessons": ["phantomstrike"],
		"roles": ["agent"],
		"starter_equipment": {
			"weapon": null,
			"armor": "justicejacket",
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
	},
	"boxer": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		"class": "guard",
		"roles": ["guard"],
		"starter_equipment": {
			"weapon": null,
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
	},
	"swordguard": {
		"allegiance": "player",
		"aggressive": true,
		"sprite": "minion",
		"class": "guard",
		"roles": ["guard"],
		"starter_equipment": {
			"weapon": "sword",
			"armor": null,
			"tool1": null,
			"tool2": null,
			"tool3": null
		},
	},
}




var factions_to_load = {
	"coalition": {
		"name": "Generic Enemy Agency",
		"waves": {
				"basic": {
					"scoutwave": 1,
				}
				#"soldiers": {
				#	"name": "Soldier Wave",
				#	"unitlists": ["soldiers"],
				#	"heatcost": 50,
				#	"weight": 8,
				#	"objectivetype": "destroy",
				#}
		},
		"color": Color.BLUE
	},
	"player": {
		"name": "Player Faction",
		"unitlists": {
			"easyharass": {
				"agent": 2,
				"generalissue": 1,
			},
			"soldiers": {
				"generalissue": 1
			}
		},
		"waves": {
				
		},
		"color": Color.REBECCA_PURPLE
	},
}

var techs = {
	"basics": {
		"name": "Everyday Evil",
		"starting": true,
		"unlocks": {
			"tech": [
				"infrastructure1"
			],
			"furn": [
				"scanpanel",
				"mine",
				"smelter",
				"crate",
				"bed",
				"oilgenerator",
				"gunsmith",
				"door",
				"pastemachine",
				"mealtable",
				"punchingbag",
				"computer",
				"heliport",
				"depot",
				"door"
			]
		}
	},
	"infrastructure1": {
		"name": "Basic Infrastructure",
		"cost": {
			"computer research": 3
		},
		"unlocks": {
			"tech": [
				
			],
			"furn": [
				"firstaid"
			]
		}
	},
	"lasers": {
		"name": "Experimental Lasers",
		"unlocks": {
			"tech": [
				
			],
			"furn": [
				
			],
			"jobs": [
				"makelaserrifle",
				"makelaserpistol",
			],
		}
	}
}

#These become Effects that apply a single stack of the modifier
var modifiers = [
	"fistpower",
	"fistaccuracy",
	"melee_power",
	"shooting_accuracy",
	"generalshootingdamage",
	"critchance",
	"armorpiercing",
	"shieldmax",
	
	#LOYALTY MODS
	"breakchance",
	"lessoncapbonus",
	"defectchance",
	"slackchance",
	
	
	
]

#each one gets a haste and efficiency mod
var worktypes = [
	"global",
	"tech",
	"science",
	"command",
	"construct",
	"manual",
	"sabotage"
]


var unit_lists_to_load = {
	"agents": {
		"units": {"agent": 5}
	},
	"flakboys": {
		"units": {"flakboy": 5}
	}
}

var mapjobs = {
	"peprally": {
		"job": "mineore",
		"speed": 10,
		"maxdetect": -1,
		"complete_func": "spawn_item_at_depot",
		"complete_args": ["metal", 10],
		"encounter": "skirmish",
	}
}

var encounters = {
	"skirmish": {
		"type": "mission",
		"mapname": "oneobjective",
		"team_goals": {
			"player": "killall",
			"coalition": "defend",
		},
		"rewards": {},
		"zones": 
			{
				"enemydeployment": [[1,1],[14,5]],
				"deployment": [[1,6],[14,14]]
			},
		"lists":
			{
				"baddies": ["agents", "flakboys"]
			},
		"goal": "killall"
	},
	"scoutwave": {
		"type": "wave",
		"key": "scoutwave",
		"objectivetype": "destroy",
		"rewards": {},
		"heatcost": 5,
		"weight": 5,
		"lists":
			{
				"baddies": ["agents", "flakboys"]
			},
		"goal": "killall"
	}
}
	
#var palette = [
#	ToolData.new("Dig/Fill", "grab_tile", [], "basic"),
#	ToolData.new("Furniture", "furni_panel", [], "basic"),
#	ToolData.new("Clear", "clear", [], "basic")
#]

var palettes = {
	"debug":
		[
			
		],
	"main":
		[
			
		]
}

var itempalette = [
	
]

var basebars = [
	"main",
	"debug",
	"items"
]

var skintones = [
	Color("#59260d"),
	Color.PAPAYA_WHIP,
]

var firstnames = [
	"Joe",
	"Greg",
	"Dave",
	"Peggy",
	"Sue",
	"Lucy",
	"Paul",
	"Clark",
	"Stan",
	"Jerry",
	"John",
	"Jane",
	"Mike",
	"Molly",
	"Mingus",
	"Ron",
	"Jack",
	"Jake",
	"Kelly",
]

var lastnames = [
	"Black",
	"White",
	"Green",
	"Brown",
	"Redd",
	"Amarillo"
]

var nicknames = [
	"Bolt",
	"Buck",
	"Gun",
	"Bubba",
	"Killer",
	"Porky",
	"Stinky",
]

var items = {}
var jobs = {}
var furniture = {}
var units = {}
var classes = {}
var powers = {}
var upgrades = {}
var factions = {}
var abilities = {}
var effects = {}
var buffs = {}

var requisitions = {}

var wizards = {
	"unit": {}
}

var lists = {
	"unit": {}
}

var waypoints = {
	"patrol": {
		"name": "Patrol",
		"type": "patrol"
	}
}

func make_condition(condata):
	var condition = rules.script_map[condata.type].new(condata)
	return condition

func _ready():
	#Effects -> Abilities -> Items -> Jobs -> Furniture -> Classes -> Units -> Powers
	load_effects()
	
	load_abilities()
	load_items()
	load_upgrades()
	load_classes()
	load_units()
	load_jobs()
	load_furniture()
	load_buffs()
	load_powers()
	load_factions()
	
	load_stats()
	
	load_requisitions()
	unit_wizards()
	unit_lists()
	
	
	
	rules.player.science.load_techs()
	rules.player.science.check_researchable()

func load_items():
	for key in items_to_load:
		var data = items_to_load[key]
		var newitem: BaseItem
		if data.has("type"):
			if data.type == "resource" || data.type == "consumable":
				newitem = BaseItem.new(data)
			elif data.type == "equipment" || data.type == "weapon" || data.type == "armor":
				newitem = BaseEquipment.new(data)
				var newabilities = []
				if data.has("abilities"):
					for abkey in data.abilities:
						var ability = abilities[abkey]
						newabilities.append(ability)
				if data.has("attack"):
					var attkey = data.attack + "ability"
					var effdata = abilities[attkey]
					newabilities.append(effdata)
				if data.has("armor"):
					var armkey = data.armor + "effect"
					var effdata = abilities[armkey]
					newabilities.append(effdata)
				newitem.equip_abilities = newabilities.duplicate()
		else:
			newitem = BaseItem.new(data)
		newitem.key = key
		if data.has("attack"):
			if weapons.has(data.attack):
				newitem.attack = weapons[data.attack]
		if data.has("protection"):
			if armors.has(data.protection):
				newitem.protection = armors[data.protection]
		newitem.id = rules.uuid(newitem)
		if newitem != null:
			items.merge({
				key: newitem
			})
			
func load_powers():
	for key in powers_to_load:
		var data = powers_to_load[key]
		var newpow = Power.new(data)
		newpow.make_tool()
		powers.merge({
			key: newpow
		})
		
			
func load_jobs():
	for key in jobs_to_load:
		var data = jobs_to_load[key]
		var newjob = JobData.new(data)
		newjob.key = key
		var reqs = {}
		for req in data.requirements:
			var value = data.requirements[req]
			if items.has(req):
				reqs.merge({
					items[req]: value
				})
		newjob.requirements = reqs
		jobs.merge({
			key: newjob
		})
			
func load_furniture():
	for key in furniture_to_load:
		var data = furniture_to_load[key]
		var newfurn = FurnitureData.new(data)
		newfurn.datakey = key
		if data.has("tags"):
			for tag in data.tags:
				if tags.has(tag):
					newfurn.tags.append(tags[tag])
		if data.has("jobs"):
			for job in data.jobs:
				if jobs.has(job):
					newfurn.jobdata.append(jobs[job])
		furniture.merge({
			key: newfurn
		})
		
func load_buffs():
	for key in buffs_to_load:
		var data = buffs_to_load[key]
		var buff = BuffBase.new(data)
		for effkey in data.effects:
			var effect = effects[effkey]
			buff.effects.merge({
				effect: data.effects[effkey]
			})
		buffs.merge({
			key: buff
		})
		
func load_modifiers():
	var mods_to_load = modifiers.duplicate()
	for work in worktypes:
		var workhaste = work + "haste"
		var workeff = work + "efficiency"
		mods_to_load.append(workhaste)
		mods_to_load.append(workeff)
	for mod in modifiers:
		var data =  {"type": "mod",
			"modifiers": {
				mod: 1
			}
		}
		var effect = BaseEffect.new(data)
		effect.effname = mod
		effects.merge({
			mod: effect
		})
	
		
func load_effects():
	var needs_effects = {}
	for key in effects_to_load:
		var data = effects_to_load[key]
		var effect: BaseEffect
		if data.type == "mod":
			effect = BaseEffect.new(data)
		elif data.type == "aura":
			effect = AuraBaseEffect.new(data)
			needs_effects.merge({effect: data.applied_effects})
		elif data.type == "attack":
			effect = AttackEffect.new(data)
		elif data.type == "armor":
			effect = ArmorEffect.new(data)
		elif data.type == "oneshot":
			effect = OneShotEffect.new(data)
		elif data.type == "overtime":
			effect = OvertimeEffect.new(data)
		effect.effname = key
		effects.merge({
			key: effect
		})
		if data.has("triggers"):
			for triggername in data.triggers:
				for triggerdata in data.triggers[triggername]:
					effect.triggers.merge({
						triggername: []
					})
					effect.triggers[triggername].append(triggerdata)
	var loading = true
	while loading:
		for i in range(needs_effects.keys().size()-1,-1,-1):
			var original = needs_effects.keys()[i]
			var effectgroup = needs_effects[original]
			var to_erase = []
			for key in effectgroup:
				if effects.has(key):
					effectgroup.merge({
						effects[key]: effectgroup[key]
					})
					
					to_erase.append(key)
			for key in to_erase:
				effectgroup.erase(key)
			original.applied_effects = effectgroup.duplicate()
			needs_effects.erase(original)
			if needs_effects == {}:
				loading = false
			pass
	load_spell_effects()
	load_attack_effects()
	load_armor_effects()
	load_modifiers()

	
func load_attack_effects():
	for key in weapons:
		var weapon = weapons[key]
		var effectdata = {
			"type": "attack",
			"weapon": key
		}
		var effname = key + "effect"
		var effect = AttackEffect.new(effectdata)
		effect.type = "attack"
		effect.effname = key
		effects.merge({effname: effect})
		
func load_spell_effects():
	for key in spells:
		var spell = spells[key]
		var effectdata = {
			"type": "spell",
			"spell": key
		}
		var effname = key + "effect"
		var effect = SpellEffect.new(effectdata)
		effect.type = "spell"
		effect.effname = key
		effects.merge({effname: effect})
		
func load_armor_effects():
	for key in armors:
		var armor = armors[key]
		var effectdata = {
			"type": "armor",
			"armor": key
		}
		var effname = key + "effect"
		var effect = ArmorEffect.new(effectdata)
		effect.type = "armor"
		effect.effname = effname
		effects.merge({effname: effect})
		
func load_spell_abilities():
	for key in spells:
		var atteffect = effects[key + "effect"]
		var ability = AbilityBase.new(self)
		ability.effects.merge({
			atteffect: 1
		})
		var abkey = key + "ability"
		ability.key = abkey
		ability.rules = rules
		abilities.merge({
			abkey: ability
		})
		
func load_attack_abilities():
	for key in weapons:
		var atteffect = effects[key + "effect"]
		var ability = AbilityBase.new(self)
		ability.effects.merge({
			atteffect: 1
		})
		var abkey = key + "ability"
		ability.key = abkey
		ability.rules = rules
		abilities.merge({
			abkey: ability
		})
		
func load_armor_abilities():
	for key in armors:
		var atteffect = effects[key + "effect"]
		var ability = AbilityBase.new(self)
		ability.effects.merge({
			atteffect: 1
		})
		var abkey = key + "ability"
		ability.key = abkey
		ability.rules = rules
		abilities.merge({
			abkey: ability
		})
		
func load_abilities():
	for key in abilities_to_load:
		var data = abilities_to_load[key]
		var base
		if data.type == "passive":
			base = AbilityBase.new(self, data)
			base.key = key
			if data.has("effects"):
				for effectdata in data.effects:
					var count = data.effects[effectdata]
					if effects.has(effectdata):
						var effect = effects[effectdata]
						base.effects.merge({
							effect: count
						})
		elif data.type == "active":
			base = ActiveAbilityBase.new(self, data)
			base.key = key
		base.rules = rules
		abilities.merge({
			key: base
		})
	load_spell_abilities()
	load_attack_abilities()
	load_armor_abilities()
					
func load_upgrades():
	for key in upgrades_to_load:
		var data = upgrades_to_load[key]
		var newbase = BaseUpgrade.new(data)
		newbase.key = key
		for effkey in data.abilities:
			var weight = data.abilities[effkey]
			if abilities.has(effkey):
				var effect = abilities[effkey]
				newbase.abilities.merge({
					effect: weight
				})
		if data.has("itemcost"):
			for itemkey in data.itemcost:
				if items.has(itemkey):
					var cost = data.itemcost[itemkey]
					var item = items[itemkey]
					newbase.itemcost.merge({
						item: cost
					})
		if data.has("item_per_scaling"):
			for itemkey in data.item_per_scaling:
				if items.has(itemkey):
					var cost = data.item_per_scaling[itemkey]
					var item = items[itemkey]
					newbase.item_per_scaling.merge({
						item: cost
					})
		upgrades.merge({
			key: newbase
		})
		
func load_origins():
	for key in origins_to_load:
		var data = origins_to_load[key]
		var newclass = Origin.new(data)
		if data.has("lessons"):
			for lessname in data.lessons:
				var lesson = upgrades[lessname]
				newclass.desired_lessons.append(lesson)
		classes.merge({
			key: newclass
		})
		
func load_classes():
	for key in classes_to_load:
		var data = classes_to_load[key]
		var newclass = UnitClass.new(data)
		if data.has("equipment"):
			for slot in data.equipment:
				if data.equipment[slot] != null:
					for item in data.equipment[slot]:
						var equipment = items[item]
						var weight = data.equipment[slot][item]
						if newclass.equipment.has(slot):
							if newclass.equipment[slot] != null:
								newclass.equipment[slot].merge({
									equipment: weight
									})
							else:
								newclass.equipment[slot] = {equipment: weight}
						else:
							newclass.equipment.merge({
								slot: [equipment]
							})
		if data.has("lessons"):
			for lessname in data.lessons:
				var lesson = upgrades[lessname]
				newclass.desired_lessons.append(lesson)
		classes.merge({
			key: newclass
		})
	rules.classes = classes.duplicate()
	load_origins()
		
func load_units():
	for key in units_to_load:
		var data = units_to_load[key]
		var newunit = UnitData.new(data)
		newunit.datakey = key
		for slot in data.starter_equipment:
			var itemname = data.starter_equipment[slot]
			if items.has(itemname):
				newunit.equipment.merge({
					slot: items[itemname]
				})
		if data.has("class"):
			if classes.has(data.class):
				newunit.unitclass = classes[data.class]
		if data.has("abilities"):
			for abilityname in data.abilities:
				if abilities.has(abilityname):
					var ability = abilities[abilityname]
					newunit.abilities.merge({
						ability: 1
					})
		units.merge({
			key: newunit
		})
	
	pass
	
func unit_wizards():
	for key in units:
		var unit = units[key]
		var unitdata = units_to_load[key]
		var equipment = {}
		var upgrades = {}
		if unitdata.has("equipment_options"):
			for slot in unitdata.equipment_options:
				var options = unitdata.equipment_options[slot]
				equipment.merge({
					slot: []
				})
				for option in options:
					var req = requisitions[option]
					equipment[slot].append(req)
		if unitdata.has("upgrade_options"):
			for slot in unitdata.upgrade_options:
				for upgrade in unitdata.upgrade_options[slot]:
					upgrades.merge({
						slot: []
					})
					var req = requisitions[upgrade]
					upgrades[slot].append(req)
			var data = {
				"base": unit,
				"equipment": equipment,
				"upgrades": upgrades,
				"upgrade_max": unitdata.upgrade_max
			}
			var wizard = UnitWizard.new(rules, self, data)
			wizards.unit.merge({
				key: wizard
			})
			var newunit = wizard.generate_unit(100)
			pass
	
func unit_lists():
	
	for key in unit_lists_to_load:
		var unitdict = {}
		var weights = {}
		var list_data = unit_lists_to_load[key]
		for unit in list_data.units:
			var weight = list_data.units[unit]
			if units.has(unit):
				var unitdata = wizards.unit[unit]
				unitdict.merge({
					unit: unitdata
				})
				weights.merge({
					unit: weight
				})
		var arg_data = {}
		var list = UnitList.new({
			"units": unitdict,
			"weights": weights
		})
		lists.unit.merge({
			key: list
		})
		var units = list.generate_units(100)
		pass
	
func load_factions():
	for key in factions_to_load:
		var data = factions_to_load[key]
		var newfaction = FactionBase.new(data)
		if data.has("unitlists"):
			for list in data.unitlists:
				var units = data.unitlists[list]
				var unitlist = UnitList.new(units)
				newfaction.unitlists.merge({
					list: unitlist
				})
		if data.has("waves"):
			for wavetype in data.waves:
				newfaction.waves.merge({
					wavetype: {}
				})
				for wavekey in data.waves[wavetype]:
					var count = data.waves[wavetype][wavekey]
					var wave = encounters[wavekey]
					newfaction.waves[wavetype].merge({
						wavekey: wave
					})
					newfaction.wave_weights.merge({
						wavekey: wave
					})
		factions.merge({
			key: newfaction
		})
		newfaction.color = data.color
	rules.factions.coalition = Faction.new(factions.coalition, rules)
	rules.factions.player = Faction.new(factions.player, rules)
	
func load_requisitions():
	for key in items:
		var item = items[key]
		var data = items_to_load[key]
		var cost = 1
		if data.has("reqcost"):
			cost = data.reqcost
		var req = Requisition.new(item, cost)
		requisitions.merge({
			key: req
		})
	for key in upgrades:
		var upgrade = upgrades[key]
		var cost = 1
		var req = Requisition.new(upgrade, cost)
		requisitions.merge({
			key: req
		})
	
func load_stats():
	for key in fuels:
		var statdata = fuels[key]
		if statdata.has("abdata"):
			fuels[key].merge({
				"abilities": []
			})
			for infdata in statdata.abdata:
				var influence = StatInfluence.new(infdata)
				if infdata.has("ability"):
					var ability = abilities[infdata.ability]
					influence.ability = ability
				fuels[key].abilities.append(influence)
	for key in qualities:
		var statdata = qualities[key]
		if statdata.has("abdata"):
			qualities[key].merge({
				"abilities": []
			})
			for infdata in statdata.abdata:
				var influence = StatInfluence.new(infdata)
				if infdata.has("ability"):
					var ability = abilities[infdata.ability]
					influence.ability = ability
				qualities[key].abilities.append(influence)
	
func tool_categories():
	toolcats = []
	for cat in cats:
		var catdata = CategoryToolData.new(cat)
		toolcats.append(catdata)
	return toolcats

func power_categories():
	powcats = []
	for cat in powcatnames:
		var catdata = CategoryToolData.new(cat)
		powcats.append(catdata)
	return powcats



func furniture_palette():
	var pal = []
	for key in furniture:
		var furn = furniture[key]
		if furn.unlocked || rules.debugvars.unlockall:
			var tool = Power.new({
				"name": furn.object_name, "on_prime": "grab_preview", "prime_args": [furn], "category": furn.category, "on_cast": "drop_furniture", "icon": furn.sprite_path})
			tool.make_tool()
			pal.append(tool)
	for key in blocks_to_load:
		var block = blocks_to_load[key]
		var tool = Power.new({
				"name": block.name, "on_prime": "preview_tile", "prime_args": [block], "category": "tiles", "on_cast": "drop_tile"})
		tool.make_tool()
		pal.append(tool)
	for key in items:
		var item = items[key]
		
		var tool = Power.new({"name": "Spawn " + item.itemname, "on_cast": "place_item_at_cursor", "cast_args": [key], "category": "itemspawn", "icon": item.sprite})
		tool.make_tool()
		pal.append(tool)
	for key in units:
		var unit = units[key]
		
		var tool = Power.new({"name": "Spawn " + key, "on_cast": "place_unit_at_cursor", "cast_args": [key], "category": "minspawn", "icon": "blueguy"})
		tool.make_tool()
		pal.append(tool)
	return pal
	
func item_categories():
	pass
	
func item_palette():
	pass
