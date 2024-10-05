extends Node2D

@onready var line = get_node("PathPointer")
@onready var heads = [
	get_node("Heads/Tip"),
	get_node("Heads/QuarterShaft"),
	get_node("Heads/ThreeFourthsShaft"),
	]
@onready var button = get_node("InsertWaypoint")

var waypoint

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func draw_path(end):
	line.points[1] = end
	var i = 1
	for head in heads:
		head.position = (end / 4) * i
		head.rotation = end.angle() + Vector2.DOWN.angle()
		i += 1
	button.position = end/ 2
	


func _on_insert_waypoint_pressed() -> void:
	waypoint.map.insert_waypoint_at_mouse("patrol", waypoint.patrol, waypoint.index+1)
