extends NavigationRegion2D

func _input(event):
   # Mouse in viewport coordinates.
	var vertices = navigation_polygon.get_vertices()
	if event is InputEventMouseButton:
		if(Geometry2D.is_point_in_polygon(event.position, vertices)):
			print("Mouse Click/Unclick at: ", event.position)
	# elif event is InputEventMouseMotion:
		# print("Mouse Motion at: ", event.position)

   # Print the size of the viewport.
	# print("Viewport Resolution is: ", get_viewport().size)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
