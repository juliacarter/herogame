extends Area2D

var radius = 32

@onready var collision = get_node("CollisionShape2D")
var shape = CircleShape2D.new()

var unit

var contents = {
	
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision.shape = shape


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func contains(id):
	return contents.has(id)
	
func set_size(newrad):
	radius = newrad
	shape.radius = radius


func _on_body_entered(area) -> void:
	if area is Furniture:
		pass
	if area.id != unit.id:
		contents.merge({
			area.id: area
		}, true)


func _on_body_exited(area) -> void:
	if area.id != unit.id:
		contents.erase(area.id)
