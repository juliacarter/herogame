extends NormalView
class_name GrayedOutView

func object_visibility(object):
	super(object)
	if object is Furniture:
		object.modulate = Color.WEB_GRAY
	if object is Square:
		object.modulate = Color.WEB_GRAY
