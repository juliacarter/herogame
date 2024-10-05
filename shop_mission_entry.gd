extends ShopEntry
#Shop entry that starts a mission for the player when purchased
class_name ShopMissionEntry

var mishname = ""

func _init(newrules, newmish, maxcount):
	super(newrules)
	prices = newmish.prices.duplicate()
	mishname = newmish.quest
	max_stocks = maxcount
	on_purchase = "buy_shop_quest"
	purchase_args = [mishname]
