@tool
extends EditorPlugin


func _enter_tree():
	# Initialization of the plugin goes here.
	add_custom_type("Unit", "CharacterBody2D", preload("unit_script.gd"), preload("res://art/goon.png"))
	add_custom_type("Furniture", "Node2D", preload("furniture.gd"), preload("res://art/goon.png"))
	add_custom_type("Ghost", "Node2D", preload("ghost.gd"), preload("res://art/goon.png"))
	add_custom_type("Footprint", "Node2D", preload("footprint.gd"), preload("res://art/goon.png"))
	add_custom_type("Grid", "Node2D", preload("grid.gd"), preload("res://art/agent.png"))
	add_custom_type("StatBlock", "Node", preload("stat_block.gd"), preload("res://art/agent.png"))
	add_custom_type("Square", "Area2D", preload("square.gd"), preload("res://art/agent.png"))
	add_custom_type("Rules", "Node", preload("rules.gd"), preload("res://art/agent.png"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_custom_type("Grid")
	remove_custom_type("Furniture")
	remove_custom_type("Ghost")
	remove_custom_type("Footprint")
	remove_custom_type("Unit")
	remove_custom_type("StatBlock")
	remove_custom_type("Square")
	remove_custom_type("Rules")
