extends HBoxContainer

signal asset_selected(selected)

var assetscene = load("res://asset_button.tscn")

var assets = []

func load_assets(new):
	for asset in new:
		var button = assetscene.instantiate()
		add_child(button)
		button.asset_selected.connect(select_asset)
		button.load_asset(asset)

func select_asset(asset):
	asset_selected.emit(asset)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
