extends RichTextLabel

@onready var data = get_node("/root/Data")
@onready var rules = get_node("/root/WorldVariables")

signal tooltip_hovered(tip)

signal tooltip_unhovered(tip)

var active_tooltip

var last_tooltip

func load_text(new):
	clear()
	var split = new.split("|")
	pass
	for block in split:
		if block.contains("`"):
			var splitblock = block.split("`")
			var tipname = splitblock[0]
			var tiptext = splitblock[1]
			var tipdata = data.tooltips[tipname]
			push_meta(tipdata)
			add_text(tiptext)
			pop()
		else:
			append_text(block)

func nest_tooltip(tip):
	if active_tooltip != null:
		active_tooltip.clear_tooltip()
	active_tooltip = rules.interface.make_tooltip(tip, true)
	if active_tooltip != null:
		if last_tooltip != null:
			last_tooltip.active_tooltip = active_tooltip
			active_tooltip.adjust_up = last_tooltip.adjust_up
			active_tooltip.adjust_right = last_tooltip.adjust_right
			active_tooltip.hovered = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_meta_hover_started(meta: Variant) -> void:
	tooltip_hovered.emit(meta)
	#nest_tooltip(meta)
	pass


func _on_meta_hover_ended(meta: Variant) -> void:
	tooltip_unhovered.emit(meta)
	pass
	#if active_tooltip != null:
		#active_tooltip.hovered = false
