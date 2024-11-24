extends Mission
class_name Investigation

func _init(gamedata, invdata, parent = null):
	super(gamedata, invdata, parent)
	var reward = ArcPhaseProgressReward.new(parent)
	success_effects.append(reward)
