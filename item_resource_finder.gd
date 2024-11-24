extends ResourceFinder
class_name ItemResourceFinder

func count():
	return rules.home.find_item_count_by_key(resource)
