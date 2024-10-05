extends ToolData
class_name CategoryToolData

func _init (newname):
	name = newname
	action = "open_category"
	category = ToolCategory.new()
	power = category
	category.catname = name
	args = [category]
