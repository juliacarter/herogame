extends Node2D

@onready var rules = get_node("/root/WorldVariables")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func normal_input(event):
	var map = rules.current_map
	if map != null:
		if event.is_pressed():
			if(event.button_index == 1):
				if rules.power != null && rules.power is Power:
					if rules.power.dragselect:
						await map.dragbox.detect_squares()
						await map.dragbox.start_drag()
					else:
						rules.power = null
				elif rules.hovered_waypoint != null:
					rules.start_waypoint_drag()
				elif rules.power == null:
					map.dragbox.detect_units()
					map.dragbox.start_drag()
		if event.is_released():
			if(event.button_index == 1):
				if rules.power == null || !(rules.power is Power):
					if map.dragbox.dragging:
						var dragged = map.dragbox.stop_drag()
						if rules.hovered_waypoint != null:
							rules.stop_drag()
							rules.select(rules.hovered_waypoint)
						else:
							if(rules.hovered != null && rules.hovered.selectable):
								rules.select(rules.hovered)
								get_parent().update_select()
							else:
								rules.select_multiple(dragged)
					elif rules.hovered_waypoint != null:
						rules.stop_drag()
						rules.select(rules.hovered_waypoint)
				elif rules.power.dragselect:
					rules.current_map.callv(rules.power.on_cast, rules.power.cast_args)
			elif(event.button_index == 2):
				if rules.power == null || !(rules.power is Power):
					if rules.selected != {}:
						if rules.selected_controllable():
							var square = map.blocks[map.highlighted.x][map.highlighted.y]
							var did_something = false
							if rules.hovered != null:
								if rules.hovered is Unit:
									for key in rules.selected:
										var object = rules.selected[key]
										if !rules.selected.has(rules.hovered.id):
											object.attack_order(rules.hovered)
											did_something = true
								elif rules.hovered is FloorItem:
									for key in rules.selected:
										var object = rules.selected[key]
										object.order_equip(rules.hovered.item)
							if !did_something:
								if square.type() == "floor":
									var pos = rules.current_map.get_global_mouse_position()
									rules.move_order(map.blocks[map.highlighted.x][map.highlighted.y], pos, Input.is_action_pressed("queue_ghosts"))
								elif square.type() == "footprint":
									var furniture = square.footprint.content
									if furniture.primary_job != null:
										for key in rules.selected:
											var object = rules.selected[key]
											if object.entity() == "UNIT":
												furniture.primary_job.make_task_for_unit(object)
				else:
					rules.fire_current_power()
	
func formation_input(event):
	if event.is_released():
		if(event.button_index == 2):
			if rules.selected != {}:
				if !rules.selected.values()[0].deployed:
					rules.place_selected_formation_unit()
				else:
					rules.fire_current_power()
	
func _unhandled_input(event):
	if event is InputEventMouseButton && !rules.on_interface:
		if rules.placing_formation:
			formation_input(event)
		else:
			normal_input(event)
	elif event is InputEventKey:
		if event.key_label == KEY_ESCAPE:
			rules.interface.open_window("gamemenu")
