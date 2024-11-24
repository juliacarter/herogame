extends Stat
class_name Fuel



var target
var filltarget

var autofill

func save():
	var save_dict = {
		"value": value,
		"title": title
	}
	return save_dict

func _init(data):
	super(data)
	max = data.num
	filltarget = data.num - 1
	target = data.newtarget
	type = "fuel"
	
	if data.has("autofill"):
		autofill = data.autofill
	
	
func copy(stat):
	title = stat.title
	category = stat.category
	max = stat.max
	value = stat.value
	target = stat.target
	filltarget = stat.filltarget
	
func load_save(savedata):
	value = savedata.value
