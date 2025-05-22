extends ResourceFinder
class_name IntangibleResourceFinder

func count():
	if rules.player.intangibles.has(resource):
		return rules.player.intangibles[resource]
	else:
		return 0
