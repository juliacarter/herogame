extends VBoxContainer
class_name SquadList

var squadscene = load("res://listed_squad.tscn")

var unit: Unit

var squads = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if unit != null:
		update_squads()

func update_squads():
	for key in squads:
		var listed = squads[key]
		var squad = listed.squad
		if !unit.squads.has(squad.id):
			remove_child(listed)
			squads.erase(squad.id)
	for key in unit.squads:
		var squad = unit.squads[key]
		var listed = squadscene.instantiate()
		listed.load_squad(squad)
		if !squads.has(squad.id):
			add_child(listed)
			squads.merge({
				squad.id: listed
			})
	

func load_unit(newunit):
	unit = newunit
	update_squads()
