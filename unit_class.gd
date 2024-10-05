extends Object
class_name UnitClass

var id

var classname = "minion"


var prospect = "agent"

var aggro = false

var equipment = {
	"armor": null,
	"weapon": null,
	"head": null,
}
var desired_lessons = []

#The criteria a unit needs to meet to be considered valid when auto-assigning classes
#Not used when assigning classes manually
var criteria = []

#If instant, lessons will be instantly learnt and equipment instantly spawned & equipped
#Use only for internal classes like the Master
var instant = false

var selectable = false

var assigned_roles = {}

func name():
	return classname
	
func save():
	var saved_equipment = {}
	for slot in equipment:
		var item = equipment[slot]
		if item != null:
			saved_equipment.merge({
				slot: item.id
			})
	var save_dict = {
		"id": id,
		"classname": classname,
		"aggro": aggro,
		"equipment": saved_equipment,
		"desired_lessons": desired_lessons,
		"assigned_roles": assigned_roles,
	}
	return save_dict
	
func _init(data):
	if data.has("name"):
		classname = data.name
	if data.has("selectable"):
		selectable = data.selectable
	if data.has("roles"):
		for key in data.roles:
			set_role(key, data.roles[key])
	if data.has("aggro"):
		aggro = data["aggro"]
			
func set_equipment(slot, base):
	if equipment.has(slot):
		equipment[slot] = {base: 1}
	else:
		if base != null:
			equipment.merge({
				slot: {base: 1}
			})


func update(data):
	if data.has("roles"):
		assigned_roles.clear()
		for key in data.roles:
			set_role(key, data.roles[key])

func clear_roles():
	for role in assigned_roles:
		assigned_roles.erase(role)
			
func set_role(role, val):
	if assigned_roles.has(role):
		assigned_roles[role] = val
	else:
		assigned_roles.merge({
			role: val
		})
