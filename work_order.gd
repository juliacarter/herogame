extends Object
class_name WorkOrder

var jobs = []
var count = 0

var waiting_jobs = []

var ordered = 0

var action = ""

func make_tasks():
	var newcount = count
	if count > 0:
		for job in jobs:
			if !job.waiting:
				var newjob = await job.location.start_job(job, true)
				
				if newjob != null:
					if !newjob.task_exists && !newjob.waiting_for_resource:
						job.waiting = true
						waiting_jobs.append(newjob)
						newcount -= 1
						ordered += 1
					
				break
	for i in range(waiting_jobs.size()-1,-1,-1):
		var job = waiting_jobs[i]
		var needs = job.check_needs()
		if job.can_make():
			#job.start_job()
			job.location.map.jobs_ordered.merge({
				job.jobname: 0
			})
			job.location.map.jobs_ordered[job.jobname] += 1
			waiting_jobs.pop_at(i)
		elif !job.waiting_for_resource:
			#fires 18 times out of 20 requests
			var can = job.get_stuff(needs)
			if can:
				job.location.map.jobs_getstuff.merge({
					job.jobname: 0
				})
				job.location.map.jobs_getstuff[job.jobname] += 1
		else:
			pass
	count = newcount
