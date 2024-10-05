extends Panel
class_name WorkScreen

@onready var grid = get_node("ScrollContainer/GridContainer")

var workscene = load("res://work_order_widget.tscn")

var jobs = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clear_jobs():
	for i in range(jobs.size() - 1, -1, -1):
		var job = jobs[i]
		grid.remove_child(job)
		jobs.pop_at(i)

func load_jobs(newjobs):
	clear_jobs()
	visible = true
	for key in newjobs:
		var jobinstances = newjobs[key]
		var newwork = workscene.instantiate()
		newwork.job = key
		newwork.jobinstances = jobinstances
		newwork.workorder = WorkOrder.new()
		newwork.workorder.jobs = jobinstances
		jobs.append(newwork)
		grid.add_child(newwork)


func _on_button_pressed() -> void:
	visible = false


func _on_confirm_pressed() -> void:
	for job in jobs:
		if job.workorder.count > 0:
			job.pop_order()
