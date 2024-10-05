extends Panel

@onready var rules = get_node("/root/WorldVariables")

var interface

@onready var list = get_node("EvilPediaList")
@onready var article = get_node("EvilPediaArticle")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interface = rules.interface


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func open_article(newarticle):
	article.load_article(newarticle)


func _on_close_button_pressed() -> void:
	rules.interface.close_window()
