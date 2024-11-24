extends Threat
class_name DoomThreat

func _init(gamedata, threatdata, newparent = null):
	super(gamedata,threatdata, newparent)
	var doom_reward = DoomReward.new(parent)
	fail_effects.append(doom_reward)
