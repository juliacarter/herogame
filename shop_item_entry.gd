extends ShopEntry
#Shop entry that creates an item at a Depot when purchased
class_name ShopItemEntry

var base

func _init(newrules, newbase, maxcount):
	super(newrules)
	base = newbase
	max_stocks = maxcount
	name = base.itemname
	on_purchase = "buy_shop_item"
	purchase_args = [base]
