extends Control

var container

var stack
var base

var shelf

var depot = false

var requesting = 0

var count = 0
var max = 0

@onready var label = get_node("Name")
@onready var amount = get_node("Amount")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stack == null:
		if shelf.contents.has(base.id):
			stack = shelf.contents[base.id]
	count = 0
	max = 0
	if stack != null:
		count = stack.count
	label.text = base.itemname
	max = count + requesting
	if stack != null:
		if shelf.requests.has(stack.base.id):
			max += shelf.requests[base.id]
	amount.text = String.num(count) + "/" + String.num(max)

func request():
	if !depot:
		if shelf.requests.has(stack.base.id):
			shelf.requests[stack.base.id] += requesting
		else:
			shelf.requests[stack.base.id] = requesting
		if requesting > 0:
			container.request_haul(stack.base, requesting)
		elif requesting < 0:
			container.request_store(stack, requesting * -1)
		requesting = 0
	else:
		if requesting > 0:
			container.depot_fill(base, requesting)
		elif requesting < 0:
			container.depot_sell(base, requesting * -1)
		requesting = 0

func _on_more_pressed():
	requesting += 1


func _on_less_pressed():
	var requests = requesting
	if shelf.requests.has(base.id):
		requests += shelf.requests[stack.base.id]
	if (stack.count + requests > 0):
		requesting -= 1
