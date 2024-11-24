extends Button

@onready var data = get_node("/root/Data")

@onready var prog = get_node("ProgressBar")

var buff

@onready var tiparea = get_node("TooltipArea")

func load_buff(new):
	buff = new
	if buff.base.tipname != "":
		var tipdata = data.tooltips[buff.base.tipname]
		tiparea.tooltip = tipdata


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if buff != null:
		prog.max_value = buff.base.duration
		prog.value = buff.time
