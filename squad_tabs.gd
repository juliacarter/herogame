extends HBoxContainer

var squadscene = load("res://squad_button.tscn")

var buttons = []
var squads = []

func clear_squads():
	for i in range(buttons.size() - 1, -1, -1):
		remove_child(buttons.pop_at(i))
		squads.pop_at(i)

func load_squads(newsquads):
	clear_squads()
	squads = []
	for key in newsquads:
		var squad = newsquads[key]
		var newsquad = squadscene.instantiate()
		newsquad.load_squad(squad)
		squads.append(squad)
		buttons.append(newsquad)
		add_child(newsquad)
	var blanksquad = squadscene.instantiate()
	blanksquad.load_blank()
	squads.append(null)
	buttons.append(blanksquad)
	add_child(blanksquad)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
