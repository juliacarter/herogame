extends Node2D

var objects = []
var queued_for_removal = []

@onready var shared_area = get_node("Area2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func add_object(object):
	var physicsdata = PhysicsData.new()
	physicsdata.current_position = object.position
	object.physicsdata = physicsdata
	physicsdata.object = object
	_configure_collision_for_object(object)
	objects.append(object)
	
func _configure_collision_for_object(physdata):
	# Step 1
	var used_transform := Transform2D()
	used_transform.origin = physdata.current_position
		
	# Step 2
	var _circle_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(_circle_shape, 8)
	# Add the shape to the shared area
	PhysicsServer2D.area_add_shape(
	shared_area.get_rid(), _circle_shape, used_transform
	)

	# Step 3
	physdata.shape_id = _circle_shape
	
func _physics_process(delta):
	var used_transform = Transform2D()
	for i in range(0, objects.size()):
		var physdata = objects[i]
		var offset: Vector2 = (
			physdata.get_vector().normalized() *
			physdata.object.movement_speed *
			delta
		)
		physdata.current_position += offset
		used_transform.origin = physdata.current_position
		PhysicsServer2D.area_set_shape_transform(shared_area.get_rid(), i, used_transform)
	for object in queued_for_removal:
		PhysicsServer2D.free_rid(object.shape_id)
		objects.erase(object)
