extends Control

@onready var rules = get_node("/root/WorldVariables")

@onready var label = get_node("Name")
@onready var amountbox = get_node("Amount")

var jobinstances
var job

var workorder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = job
	#amountbox.value = workorder.count


func pop_order():
	rules.workorders.append(workorder)
	workorder = WorkOrder.new()
	workorder.jobs = jobinstances

func _on_more_pressed() -> void:
	amountbox.value += 1


func _on_amount_value_changed(value: float) -> void:
	workorder.count = value
