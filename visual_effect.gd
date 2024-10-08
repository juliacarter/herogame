extends Object
class_name VisualEffect


#SELF = unit performs the animation. ACTIONS SHOULD ONLY EVER HAVE 1 SELF OR TARGET ANIMATION
#TARGET = target performs the animation
#AttackBeam/AttackProjectile = create a Node for the animation, then the new Node performs the animation. will automatically target the action's target
var type = ""

#the sprite used by the animation, if any
var sprite = ""

#the animation file to play, if any
var animation = ""

var speed = 100.0

var lifetime = 0.0

var on_success = true

var on_fail = true

func _init(animdata):
	if animdata.has("type"):
		type = animdata.type
	if animdata.has("sprite"):
		sprite = animdata.sprite
	if animdata.has("animation"):
		animation = animdata.animation
	if animdata.has("lifetime"):
		lifetime = animdata.lifetime
	
