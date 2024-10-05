extends Panel

@onready var rules = get_node("/root/WorldVariables")

@onready var classpicker = get_node("ClassOptions")

@onready var namelabel = get_node("ClassName")

@onready var picker = get_node("Picker")

@onready var lessonlist = get_node("AbilityContainer/LessonList")

@onready var paperdoll = get_node("InventoryContainer/PaperDoll")

var classes = []

var selected_class

var new_lessons = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_classes()
	initial_open()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_classes():
	classes = []
	classpicker.clear()
	
	for key in rules.classes:
		var unitclass = rules.classes[key]
		if unitclass.selectable || rules.debugvars.assignanything:
			classes.append(unitclass)
			classpicker.add_item(unitclass.classname)

func initial_open():
	var newclass = rules.classes.values()[0]
	paperdoll.parent = self
	pass
	load_class(newclass)

func open_lessonpicker():
	picker.load_options(self, "lessons", true)
	picker.visible = true
	
func open_equipmentpicker(slotname):
	picker.load_equipment_options(self, slotname, false)
	picker.visible = true

func pick_item(item, picking_slot):
	if picking_slot == "lessons":
		for lesson in item:
			new_lessons.merge({
				lesson.key: lesson
			})
	reload_lessons()
	#load_class(selected_class)
			
func remove_lesson(item):
	new_lessons.erase(item.key)

func load_class(newclass):
	load_classes()
	
	paperdoll.parent = self
	lessonlist.panel = self
	if newclass != null:
		selected_class = newclass
		classpicker.selected = classes.find(selected_class)
	var lessons = []#unit.known.duplicate()
	new_lessons = {}
	for lesson in selected_class.desired_lessons:
		#var lesson = unit.learning[key]
		lessons.append(lesson)
		new_lessons.merge({
			lesson.key: lesson
		})
	paperdoll.load_slots(selected_class)
	#var abilities = []
	#for key in unit.abilities:
		#var ability = unit.abilities[key]
		#abilities.append(ability)
	reload_lessons()
	#lessonlist.load_items(lessons, "lessons")
	#abilitylist.load_items(abilities, "abilities", false)
	namelabel.text = selected_class.classname
	#fuellist.load_bars(unit)
	#paperdoll.load_slots(unit)
	#squadlist.load_unit(unit)
	
func reload_lessons():
	var lessons = []
	for key in new_lessons:
		var lesson = new_lessons[key]
		lessons.append(lesson)
	lessonlist.load_items(lessons, "lesson")
		


func _on_commit_pressed() -> void:
	var lessons = []
	for key in new_lessons:
		var lesson = new_lessons[key]
		lessons.append(lesson)
	selected_class.desired_lessons = lessons


func _on_new_class_pressed() -> void:
	var newclass = rules.new_class()
	load_classes()
	load_class(newclass)
	paperdoll.parent = self


func _on_class_options_item_selected(index: int) -> void:
	var newclass = classes[index]
	load_class(newclass)


func _on_hire_class_pressed() -> void:
	rules.hire_class(selected_class)
