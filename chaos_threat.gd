extends Threat
class_name ChaosThreat

func _init(gamedata, threatdata, newparent = null):
	super(gamedata,threatdata, newparent)
	if threatdata.has("chaos_amount"):
		var chaos_reward = ChaosReward.new(threatdata.chaos_amount)
		fail_effects.append(chaos_reward)
