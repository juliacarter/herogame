extends VBoxContainer

var barscene = load("res://fuel_bar.tscn")
var labelscene = load("res://stat_indicator.tscn")

var bars = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_bars():
	for i in range(bars.size()-1,-1,-1):
		var bar = bars[i]
		remove_child(bar)
		bars.pop_at(i)

func load_bars(newbars):
	clear_bars()
	for statname in newbars:
		var stat = newbars[statname]
		var bar
		if stat is Fuel:
			bar = barscene.instantiate()
		else:
			bar = labelscene.instantiate()
		bar.load_stat(stat)
		add_child(bar)
		bars.append(bar)
