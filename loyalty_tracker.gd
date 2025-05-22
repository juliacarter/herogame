extends Object
class_name LoyaltyTracker

#the unit's current Loyalty
var loyalty = 0

#known precision of the unit's loyalty
#0 = Exact loyalty known
var known_loyalty = 0

var factors = {}

var known_factors = {}
var unknown_factors = {}

#add a LoyaltyFactor
func add_factor(factor, known = false):
	factors.merge({
		factor: true
	})
	if known:
		reveal_factor(factor)
		
func roll_reveal():
	pass
		
func reveal_factor(factor):
	unknown_factors.erase(factor)
	known_factors.merge({
		factor: true
	})
	
func hide_factor(factor):
	known_factors.erase(factor)
	unknown_factors.merge({
		factor: true
	})
	
func remove_factor(factor):
	pass
	
func calculate_known_loyalty():
	var total = 0
	for factor in known_factors:
		if factor.known:
			total += factor.value
	known_loyalty = total
