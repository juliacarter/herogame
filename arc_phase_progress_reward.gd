extends Reward
class_name ArcPhaseProgressReward

var phase

var objective

func _init(new):
	phase = new
	function = "progress_arc_phase"
	
func get_reward():
	return {
		"function": function,
		"args": [phase, 1]
	}
