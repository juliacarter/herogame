extends Object
class_name Region

var id
#Schemes that can be bought in this region, organized by type
var schemes = {}
var scheme_cooldown = 0.0

#Opportunities that can be found in the region, organized by type and weighted
var opportunities = {}

#scan progress until the next Opportunity is revealed
var opportunity_scan = 10.0

#The region's Traits
var traits = []

#Maps functioning as bases in the region
var bases = []
#Maps functioning as encounters in the region
var encounters = []
#Contacts within the region
var contacts = []
#Shops in the region
var stores = []
#Active worksites in the region
var worksites = []
#Assets in the region that can be claimed
var assets = []

#Influence in the region, by faction
var influence = {}

var scheme_active = false

func think(delta):
	if !scheme_active:
		if scheme_cooldown > 0:
			scheme_cooldown -= delta
		else:
			scheme_cooldown = 0

func add_influence(faction, amount):
	influence.merge({
		faction: 0.0
	})
	influence[faction] += amount
	
func remove_influence(faction, amount):
	if influence.has(faction):
		influence[faction] -= amount
		if influence[faction] <= 0:
			influence.erase(faction)
