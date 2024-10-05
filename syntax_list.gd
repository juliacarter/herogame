extends Panel

@onready var syntaxbox = get_node("ScrollContainer/SyntaxBox")
var syntaxscene = load("res://syntax_holder.tscn")

var owned_by

var screen

var syntaxes = []

var slot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_syntax():
	for syn in syntaxes:
		syntaxbox.remove_child(syn)
	syntaxes = []

func save_syntax():
	for i in range(syntaxes.size()-1,-1,-1):
		var crit = syntaxes[i]
		if !crit.save_syntax():
			remove_syntax(crit)
		elif !crit.saved:
			owned_by.add_syntax(slot, crit.syntax)
			crit.saved = true

func add_syntax(syn):
	var synholder = syntaxscene.instantiate()
	synholder.screen = screen
	syntaxbox.add_child(synholder)
	synholder.load_syntax(syn)
	syntaxes.append(synholder)
	return synholder

func remove_syntax(holder):
	var syn = holder.syntax
	owned_by.remove_syntax(slot, syn)
	syntaxes.pop_at(syntaxes.find(holder))
	
func _on_add_crit_pressed() -> void:
	screen.open_picker(screen, slot)
