extends Object
#an Asset that can be built in a region
class_name Asset

#the region the asset is built in
var region

#the faction that owns the asset
var faction

#missions targeting this asset
#threats and schemes
var missions = []

var title = "asset"

var rules

func name():
	return title

func _init(newrules, assetdata):
	rules = newrules
	if assetdata.has("name"):
		title = assetdata.name

#implement this for each Asset type
func think(delta):
	pass
