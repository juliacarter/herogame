extends ResourceObjective
#An objective type where an intangible resource must be spent through the quest interface
class_name ResourceSpendObjective

#Becomes completable when the play has required resource, enabling the spend button
var completable = false

var spent = false

func get_log_text():
	if !completed:
		var has = rules.player.intangibles[resource]
		return resource + ": " + String.num(has) + "/" + String.num(amount)
	else:
		return resource + ": " + String.num(amount) + "/" + String.num(amount) + "!"
		
func can_fire():
	var has = rules.player.intangibles[resource]
	completable = has >= amount
	return completable
		
#Called when the objective's quest log button is pressed, finalizing the objective
func fire():
	rules.player.intangibles[resource] -= amount
	spent = true
		
func status_function():
	return spent
