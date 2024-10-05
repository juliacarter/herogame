extends Object
#Generic shop item class
#Fires a function X times when purchased
class_name ShopEntry

var name = "shopitem"

var rules

#When the item is purchased, triggers this function for each stock purchased
var on_purchase = ""
var purchase_args = []

#The price of the item, split between various Intangibles
var prices = {
	"cash": 10,
	"influence": 20
}
#The heat gained from buying the item, per stock
var heat = 0

#The time it takes to restock a single stock of this item
#restock_time = -1 for no restock/scripted restock
var restock_time = 100

#The maximum number of items a shop can have in stock
var max_stocks = 1

var stocks = 0

func _init(newrules):
	rules = newrules
	
func buy_count(count):
	rules.buy_entry(self, count)
