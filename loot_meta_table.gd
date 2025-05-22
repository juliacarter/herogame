extends WeightedRollTable
class_name LootMetaTable
#a roll table made up of other tables, for unit drops & mish rewards



#roll a number of drops from the table. if count is -1, roll for count
#func roll(count = -1):
	#pass

func _init(newitems):
	for item in newitems:
		var weight = newitems[item]
		var newtable = WeightedRollTable.new(item)
		items.merge({
			newtable: weight
		})
	#items = {
	#	WeightedRollTable.new(
	#		{
	#			"metal": 3,
	#			"chemical": 1,
	#		}
	#	): 5,
	#	WeightedRollTable.new(
	#		{
	#			"flak": 5,
	#			"popper": 3
	#		}
	#	): 10,
	#}

func roll(count = -1):
	var tables = super(count)
	var result = []
	result.resize(tables.size())
	var pos = 0
	for table in tables:
		var rolled = table.roll(1)
		result[pos] = rolled[0]
		pos += 1
	pass
	return result
