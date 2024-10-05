extends HBoxContainer

var toastscene = load("res://toast.tscn")

var toasts = []

func make_toast(toastdata):
	var toast = toastscene.instantiate()
	toast.parent = self
	toast.load_toast(toastdata)
	toasts.append(toast)
	add_child(toast)
	
func remove_toast(toast):
	var i = toasts.find(toast)
	if i != -1:
		remove_child(toast)
		toasts.pop_at(i)
		
func clear_toasts():
	for i in range(toasts.size()-1,-1,-1):
		var toast = toasts[i]
		remove_child(toast)
		toasts.pop_at(i)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
