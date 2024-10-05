@tool
extends Node
class_name StatBlock
	
@export var stat_dict = {}

func _ready():
	var world_vars = get_node("/root/WorldVariables")
	for stat in world_vars.base_stats:
		if(!stat_dict.has(stat.name)):
			stat_dict.merge({stat.name: stat})
			
