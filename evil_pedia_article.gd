extends Control

@onready var title = get_node("FlowContainer/Title")
@onready var body = get_node("FlowContainer/Body")

var article

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_article(newarticle):
	article = newarticle
	title.text = article.title
	body.text = article.body
