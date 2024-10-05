extends ShopItemEntry
class_name ShopItemSellEntry

func _init(newrules, newbase, maxcount):
	super(newrules, newbase, maxcount)
	base = newbase
	max_stocks = maxcount
	name = base.itemname
	prices = {}
	on_purchase = "sell_shop_item"
	purchase_args = [base]
