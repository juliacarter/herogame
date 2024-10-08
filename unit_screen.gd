extends Panel

@onready var rules = get_node("/root/WorldVariables")

@onready var paperdoll = get_node("InventoryContainer/PaperDoll")
@onready var lessonholder = get_node("UpgradeScroller/UpgradeContainer/LessonHolder")
@onready var upgradeholder = get_node("UpgradeScroller/UpgradeContainer/UpgradeHolder")
@onready var abilitylist = get_node("AbilityScroller/AbilityList")

@onready var picker = get_node("Picker")

@onready var namelabel = get_node("UnitName")
@onready var fuellist = get_node("StatsContainer/FuelList")
@onready var qualitylist = get_node("StatsContainer/QualityList")
@onready var squadlist = get_node("Panel3/SquadList")
@onready var classpicker = get_node("ClassOptions")
@onready var attackpicker = get_node("AttackOption")
@onready var secondarypicker = get_node("SecondaryAttack")

@onready var explabel = get_node("Label2")
@onready var levelbar = get_node("ProgressBar")
@onready var levelindic = get_node("Label")

@onready var lessons = get_node("UpgradePicker")

var lessonlist: AnythingList
var upgradelist: AnythingList

var classes = []
var attacks = []


var selected_class

var unit

var listscene = preload("res://anything_list.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lessonlist = listscene.instantiate()
	upgradelist = listscene.instantiate()
	lessonholder.load_items([lessonlist])
	upgradeholder.load_items([upgradelist])
	lessonlist.panel = self
	upgradelist.panel = self
	paperdoll.parent = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	levelbar.value = unit.experience
	levelbar.max_value = unit.needed_experience
	explabel.text = String.num(unit.experience) + "/" + String.num(unit.needed_experience)
	levelindic.text = String.num(unit.cultivation.lesson)
	
func load_attacks():
	if unit != null:
		attacks = []
		for key in unit.attacks:
			var attack = unit.attacks[key]
			if key != "fist":
				attacks.append(attack)
				attackpicker.add_item(key)
				secondarypicker.add_item(key)

func load_classes():
	if unit != null:
		classes = []
		classpicker.clear()
		for key in rules.classes:
			var unitclass = rules.classes[key]
			if unitclass.selectable || rules.debugvars.assignanything:
				classes.append(unitclass)
				classpicker.add_item(unitclass.classname)

func load_unit(newunit):
	unit = newunit
	load_classes()
	load_attacks()
	lessonlist.panel = self
	if unit.unit_class != null:
		selected_class = unit.unit_class
		classpicker.selected = classes.find(selected_class)
	var lessons = unit.upgrades.duplicate()
	for key in unit.upgrading.lesson:
		var lesson = unit.upgrading.lesson[key]
		lessons.append(lesson)
	#var upgrades = unit.upgrades.duplicate()
	for key in unit.upgrading.augment:
		var lesson = unit.upgrading.augment[key]
		lessons.append(lesson)
	var abilities = []
	for key in unit.abilities:
		var ability = unit.abilities[key]
		abilities.append(ability)
	await lessonlist.load_items(lessons, "lesson")
	#await upgradelist.load_items(upgrades, "augment")
	abilitylist.load_items(abilities, "abilities", false)
	namelabel.text = unit.object_name()
	fuellist.load_bars(unit.stats.fuels)
	qualitylist.load_bars(unit.stats.qualities)
	paperdoll.load_slots(unit)
	squadlist.load_unit(unit)

func open_upgradepicker(type):
	picker.load_options(self, type, true)
	picker.visible = true
	
#func open_equipmentpicker(slotname):
	

func _on_class_options_item_selected(index: int) -> void:
	selected_class = classes[index]

func pick_item(item, picking_slot):
	if picking_slot == "lesson" || picking_slot == "augment":
		for lesson in item:
			unit.start_lesson(lesson)

func _on_commit_pressed() -> void:
	if unit != null:
		unit.change_class(selected_class)


func _on_button_pressed() -> void:
	unit.level_up()


func _on_button_2_pressed() -> void:
	unit.gain_experience("combat", 99)


func _on_inner_circle_button_pressed() -> void:
	rules.player.inner_circle_add(unit)


func _on_attack_option_item_selected(index: int) -> void:
	var item = attackpicker.get_item_text(index)
	unit.attack_slots.main = item


func _on_secondary_attack_item_selected(index: int) -> void:
	var item = attackpicker.get_item_text(index)
	unit.attack_slots.secondary = item


func _on_lesson_pick_pressed() -> void:
	lessons.visible = true
	lessons.load_unit(unit)
