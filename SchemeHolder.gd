extends Object

var rules

#Schemes the holder can choose from, organized by weight
var schemes = {}

var region

var type = ""

func _init(gamedata, newtype):
	type = newtype
	for key in gamedata.schemes:
		var scheme = gamedata.schemes[key]
		if scheme.type == type:
			var weight = scheme.weight
			schemes.merge({
				key: weight
			})
