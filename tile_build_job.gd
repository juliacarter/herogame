extends BuildJob
class_name TileBuildJob

var tiledata
var square

func _init(newsquare, newtiledata):
	tiledata = newtiledata
	square = newsquare
	location = square
	var slot = WorkSlot.new({"title": "interact", "count": 1, "max": 0, "role": "builder", "reserving": true, "modifiers": []})
	desiredactors.merge({
		"interact": slot
	})
	action = "make_tile"
	type = "interact"
	args = [tiledata]

func make_tile(tiledata):
	square.set_content(tiledata)
	
func complete():
	await callv(action, args)
	started = false
	done = true
	task_exists = false
	waiting_for_resource = false
	for key in desiredactors:
		for actor in desiredactors[key].actors:
			await actor.finish_task()
	for item in neededitems:
		var count = neededitems[item]
		square.remove_item(item.id, count, "input")
	
func can_do():
	var can = true
	for key in desiredactors:
		var slot = desiredactors[key]
		for actor in slot.actors:
			if !square.can_interact.has(actor.id):
				can = false
	return can
