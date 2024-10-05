extends Panel

@onready var picker = get_node("SelectClass")

@onready var rules = get_node("/root/WorldVariables")
@onready var data = get_node("/root/Data")

@onready var roleselector = get_node("RoleSelector")

@onready var roles = get_node("RoleContainer")

@onready var namebox = get_node("TextEdit")

var rolebuttonscene = load("res://role_button.tscn")

var classes = []

var classname = "minion"

var selected_class
var editing_class

var available_roles = []
var available_lessons = []

var selected_roles = {}
var selected_lessons = {}

var selected_equipment = {}

var aggression = false

func load_classes(newclasses):
	classes.clear()
	picker.clear()
	picker.add_item("null")
	classes.append(null)
	for key in newclasses:
		var newclass = newclasses[key]
		classes.append(newclass)
		picker.add_item(newclass.classname)

# Called when the node enters the scene tree for the first time.
func _ready():
	roleselector.parent = self
	load_classes(rules.classes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func select_class(newclass):
	selected_class = newclass
	if selected_class != null:
		load_class(selected_class)
	else:
		clear_class()
		
func clear_class():
	for key in selected_roles:
		var role = selected_roles[key]
		roles.remove_child(role)
	for key in selected_roles:
		selected_roles.erase(key)
	for key in selected_lessons:
		pass
	for slot in selected_equipment:
		pass
	
func load_class(newclass):
	clear_class()
	for role in newclass.assigned_roles:
		add_role(role)
	for key in newclass.equipment:
		selected_equipment[key] = newclass.equipment[key]
	classname = newclass.classname
	pass
	
func save_class():
	if selected_class == null || namebox.text != selected_class.classname:
		var newclass = UnitClass.new({
			"name": namebox.text
			})
		for role in selected_roles:
			newclass.set_role(role, 1)
		newclass.id = rules.uuid(newclass)
		rules.save_class(newclass)
		load_classes(rules.classes)
		select_class(newclass)
		picker.selected = picker.item_count - 1
	else:
		selected_class.update({
			"roles": selected_roles,
			"aggro": aggression,
		})
		pass
	
func make_class():
	pass

func commit():
	save_class()

func add_role(role):
	var newrole = rolebuttonscene.instantiate()
	newrole.load_role(role)
	newrole.parent = self
	newrole.adding = false
	selected_roles.merge({
		role: newrole
	}, true)
	roles.add_child(newrole)
	
func remove_role(role):
	var newrole = selected_roles[role]
	selected_roles.erase(role)
	roles.remove_child(newrole)

func _on_add_role_pressed():
	roleselector.load_roles(data.roles)


func _on_commit_pressed():
	commit()


func _on_select_class_item_selected(index):
	select_class(classes[index])


func _on_aggression_toggled(toggled_on):
	aggression = toggled_on
