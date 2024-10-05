extends Object
class_name StatInfluence

var ability: AbilityBase# -- the Effect applied
var threshold: int = 0# -- the value which this effect is applied, if doesnt exist threshold = 0
var threshold_above: bool = true# -- whether the effect is applied above the threshold, or below if false, if doesn't exist set = true
var stacks: int = 1# -- the amount applied for each bracket, if doesn't exist stacks = 1
var bracket: int = 0# -- the amount of each variable needed to increase the value, if doesn't exist set = 0 (meaning unit get 1 stack as long as the threshold is met, and none otherwise)

func _init(data):
	if data.has("threshold"):
		threshold = data.threshold
	if data.has("threshold_above"):
		threshold_above = data.threshold_above
	if data.has("stacks"):
		stacks = data.stacks
	if data.has("bracket"):
		bracket = data.bracket
