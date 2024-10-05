extends Object
class_name SellOrder

#1. Create Sell Order
#2. Request Hauls to sell_point
#3. Keep checking sell_point to see if it has sellable items and sell if possible
#4. When still_needed is empty, complete sell order

var rules

#Items that have been successfully brought to the drop-off to sell
var sent_items = {}

#ALl items that are being sold
var desired_items = {}

#Items that have been ordered but not brought yet
var still_needed = {}

#Hauling tasks associated with the sell order
var tasks = {}

var bases = {}

#The point items need to be taken to for selling
var sell_point

func _init(gamerules):
	rules = gamerules
	sell_point = rules.home.active_depot
	
func order_item(base, amount):
	if desired_items.has(base.key):
		pass
	else:
		sell_point.request(base, amount, "sell")
		bases.merge({
			base.key: base
		})
		desired_items.merge({
			base.key: amount
		})
		
#Check to see if the sell_point has the desired items, selling any it finds
func check_items():
	for key in desired_items:
		var count = desired_items[key]
		var base = bases[key]
		var has = sell_point.shelves.sell.has(base, count)
		if has != 0:
			var sold = send_items(base, has)
			if sent_items.has(key):
				sent_items[key] += sold
			else:
				sent_items.merge({
					key: sold
				})
			if sent_items[key] >= desired_items[key]:
				return true
	return false
		
func send_items(base, count):
	var sold = sell_point.depot_sell(base, count)
	return sold
		
func request_items():
	for key in desired_items:
		var needs = 0
		if sent_items.has(key):
			var diff = desired_items[key] - sent_items[key]
