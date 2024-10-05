extends Stat
class_name Skill

var min

var growthrate
var decayrate

func _init(data):
	super(data)
	max = 99999999999999

func decay(delta):
	var modifier = delta * decayrate * -1
	modify(modifier)
