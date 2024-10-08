extends Object
class_name SoundBubbleData

#bubble sprites that can be chosen for this popup
var bubbles = []

#the shape of the path the bubble follows
var path = ""

#the amount of time the bubble stays visible
var lifetime = 1.0

#SELF = bubble appears on object that called for it
var target = "SELF"

#chance for the bubble to appear when called for
var chance = 50

func _init(bubbledata):
	if bubbledata.has("bubbles"):
		bubbles = bubbledata.bubbles.duplicate()
	if bubbledata.has("path"):
		path = bubbledata.path
	if bubbledata.has("lifetime"):
		lifetime = bubbledata.lifetime
