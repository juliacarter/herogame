extends Object
class_name JobBase

var rules

var location
var jobdata

var served = false

var jobname

var taskmaster

var automatic

var slots

var service = false

var certs = {}

var waiting = false




func _init(newjob, loc):
	jobdata = newjob
	slots = jobdata.slots.duplicate()
	certs = jobdata.certs.duplicate()
	automatic = jobdata.automatic
	service = jobdata.service
	jobname = jobdata.jobname
	location = loc
	taskmaster = location.map.taskmaster
	
func can_serve():
	if served:
		return true
	if slots.has("serve"):
		if location.spots.has("serve"):
			if location.spots_filled("serve", "jobdata"):
				return true
		return false
	else:
		return true
		
func request_serve():
	var task = ServiceTask.new("worker", location.get_global_position(), null, "service", location, self)
	served = true
	location.map.taskmaster.add_task(task)

func can_make():
	if can_serve():
		return true

func is_certified(unit, slot):
	if certs == {}:
		return true
	var result = true
	for cert in certs[slot]:
		if !unit.modifiers.has(cert):
			result = false
	return result

func make_job():
	var job
	if jobdata.jobclass != "":
		var jobclass = rules.script_map[jobdata.jobclass]
		job = jobclass.new(jobdata, location.map)
	job.jobbase = self
	#location.in_use = true
	job.taskmaster = taskmaster
	if service:
		if can_serve():
			if job.desiredactors.has("serve"):
				job.desiredactors.serve.actors = location.get_spot_actors("serve").duplicate()
	job.rules = rules
	job.taskmaster = taskmaster
	return job
