extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var researchlabel = get_node("ScrollContainer/VBoxContainer/ResearchLabel")
@onready var boldnesslabel = get_node("ScrollContainer/VBoxContainer/BoldnessLabel")
@onready var wealthlabel = get_node("ScrollContainer/VBoxContainer/WealthLabel")

@onready var builduplabel = get_node("ScrollContainer/VBoxContainer/BuildupLabel")

@onready var desclabel = get_node("ScrollContainer/VBoxContainer/RichTextLabel")

var faction

func load_faction(new):
	faction = new

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if faction != null:
		researchlabel.text = "RESEARCH: " + String.num(faction.research)
		boldnesslabel.text = "BOLDNESS: " + String.num(faction.boldness)
		wealthlabel.text = "WEALTH: " + String.num(faction.wealth)
		builduplabel.text = "BUILDUP: " + String.num(faction.buildup) + "/" + String.num(faction.buildup_to_doom)
