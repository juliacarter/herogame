extends Panel

@onready var grid = get_node("GridContainer")

var buttonscene = load("res://job_button.tscn")

var furniture

var jobs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func load_jobs(newjobs):
	clear_jobs()
	for key in furniture.job_options:
		var option = furniture.job_options[key]
		var button = buttonscene.instantiate()
		jobs.append(button)
		button.load_job(option)
		grid.add_child(button)
	
func clear_jobs():
	for i in range(jobs.size()-1, -1, -1):
		var job = jobs.pop_at(i)
		grid.remove_child(job)
	
func load_furniture(newfurn):
	furniture = newfurn
	load_jobs(furniture.job_options)
