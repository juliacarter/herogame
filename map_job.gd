extends Object
class_name MapJob

var rules

var id

var tab

#a Job object used to track the actual job progress
var job: Job
#MapJob is essentially a Job with logic that allows it to be worked without a physical location

#encounter to send units to if caught
var encounter = ""

var speed = 0
var time = 0

#maximum Detection that can be built up before triggering a combat encounter
#if -1, detection doesn't apply here
var maxdetect = 0

#current detection built up
var detection = 0

#units at the jobsite
var units = {}

#units assigned to this job
var assigned_units = []
var squads = []

#assigned units sorted by allegiance
var units_by_team = {}

var landed_units = {}

var start_func = ""
var start_args = []

var complete_func = ""
var complete_args = []

#whether or not transport has landed & job is doable
var landed = false

var transport

func think(delta):
	for key in landed_units:
		var unit = landed_units[key]
		var amount = unit.work_value(delta)
		time -= (amount + delta)
	if time <= 0:
		complete()
		
func complete():
	await rules.callv(complete_func, complete_args)
	landed_units = {}
	time = speed
	transport.needs_placement = false
	await transport.set_target(rules.home)
	for key in units:
		var unit = units[key]
		await transport.store_unit(unit)
	transport.moving = true
	rules.interface.maptabs.close_tab(self)

func land_units(new):
	for key in new:
		var unit = new[key]
		landed_units.merge({
			key: unit
		})

func add_squad(squad):
	squads.append(squad)
	for key in squad.units:
		var unit = squad.units[key]
		add_unit(unit)
		
func add_unit(unit):
	unit.encounter = self
	units.merge({
		unit.id: unit
	})
	units_by_team.merge({
		unit.allegiance: {}
	})
	units_by_team[unit.allegiance].merge({
		unit.id: unit
	})
	#for order in orders:
		#unit.add_order(order)

func send_squads():
	for squad in squads:
		rules.transport_order(self)

func _init(gamerules, jobdata):
	rules = gamerules
	if jobdata.has("speed"):
		speed = jobdata.speed
		time = speed
	if jobdata.has("complete_func"):
		complete_func = jobdata.complete_func
	if jobdata.has("complete_args"):
		complete_args = jobdata.complete_args.duplicate()
	if jobdata.has("start_func"):
		start_func = jobdata.start_func
	if jobdata.has("start_args"):
		start_args = jobdata.start_args.duplicate()
	if jobdata.has("maxdetect"):
		maxdetect = jobdata.maxdetect
	if jobdata.has("encounter"):
		encounter = jobdata.encounter
