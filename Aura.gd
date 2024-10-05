extends Node2D
class_name Aura

@onready var visioncone = get_node("VisionCone2D")

var effect: AuraBaseEffect

var radius = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visioncone.max_distance = radius


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func make_aura(neweffect):
	radius = neweffect.auradata.radius
	effect = neweffect
	if is_node_ready():
		visioncone.max_distance = radius


func _on_vision_cone_area_entered(area: Area2D) -> void:
	for applied in effect.applied_effects:
		var count = effect.applied_effects[applied]
		area.apply_effect(applied, count)


func _on_vision_cone_area_exited(area: Area2D) -> void:
	for applied in effect.applied_effects:
		var count = effect.applied_effects[applied]
		area.remove_effect(applied, count)
