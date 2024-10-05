extends Object
class_name Conversation

var time = 1.0

var done = false

var members = []

var conversation_point: Vector2

func _init(point):
	conversation_point = point

func speak(delta):
	time -= delta
	if time <= 0:
		done = true
		
func can_talk():
	for member in members:
		for member2 in members:
			if member != member2:
				if !member.can_interact.has(member2.id):
					return false
	return true
		
func finish_conversation():
	pass
