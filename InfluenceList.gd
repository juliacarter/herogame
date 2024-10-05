extends VBoxContainer

var region

var influences = {}
var labels = {}

func load_region(new):
	region = new

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if region != null:
		for faction in region.influence:
			var value = region.influence[faction]
			if !influences.has(faction):
				influences.merge({
					faction: value
				})
				var label = Label.new()
				labels.merge({
					faction: label
				})
				label.text = faction + " " + String.num(value)
				add_child(label)
			else:
				var label = labels[faction]
				label.text = faction + " " + String.num(value)
		for faction in influences:
			if !region.influence.has(faction):
				var label = labels[faction]
				remove_child(label)
				influences.erase(faction)
				labels.erase(faction)
