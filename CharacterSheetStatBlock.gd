extends Control

@onready var bars = {
	"focus": get_node("ScrollContainer/HBoxContainer/VBoxContainer/FocusBar"),
	"morale": get_node("ScrollContainer/HBoxContainer/VBoxContainer/MoraleBar"),
	"health": get_node("ScrollContainer/HBoxContainer/VBoxContainer/HealthBar"),
}

var unit

func load_unit(new):
	unit = new
	load_fuel()

func load_fuel():
	bars.focus.stat = unit.all_stats.energy
	bars.morale.stat = unit.all_stats.morale
	bars.health.stat = unit.all_stats.health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
