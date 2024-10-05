extends Button

@onready var rules = get_node("/root/WorldVariables")

var furn

var job

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_job(newjob):
	job = newjob
	text = job.jobname
	furn = job.location


func _on_pressed():
	job.make_job()
