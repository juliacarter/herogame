extends Tree


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var item1 = create_item()
	#var lab1 = Label.new()
	#lab1.text = "this is a tree item!"
	item1.set_text(0, "this is a tree item!")
	var sub1 = item1.create_child()
	sub1.set_text(0, "this is a subtree item!")
	var sub2 = sub1.create_child()
	sub2.set_text(0, "this is a subtree item!")
	var item2 = create_item()
	var sub3 = item2.create_child()
	sub3.set_text(0, "this is a subtree item!")
	var item3 = create_item()
	var sub4 = item3.create_child()
	sub4.set_text(0, "this is a subtree item!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
