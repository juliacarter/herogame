extends Object
class_name QuadTree

var totalbound
var boundary
var center

var objects = []

var point
var depth = 0

var ne
var nw
var se
var sw

var east
var west
var north
var south

var divided

var parent

var type

func _init(cent, bounds, newdepth, newparent, newtype):
	center = cent
	boundary = bounds
	west = center.x - bounds.w/2
	east = center.x + bounds.w/2
	south = center.y - bounds.h/2
	north = center.y + bounds.h/2
	depth = newdepth
	parent = newparent
	type = newtype
	if parent == null:
		totalbound = boundary
	else:
		totalbound = parent.totalbound
	divided = false

func divide():
	var w = boundary.w / 2.0
	var h = boundary.h / 2.0
	ne = QuadTree.new(Vector2(center.x+w/2, center.y-h/2), {"w": w, "h": h}, depth+1, self, type)
	nw = QuadTree.new(Vector2(center.x-w/2, center.y-h/2), {"w": w, "h": h}, depth+1, self, type)
	se = QuadTree.new(Vector2(center.x+w/2, center.y+h/2), {"w": w, "h": h}, depth+1, self, type)
	sw = QuadTree.new(Vector2(center.x-w/2, center.y+h/2), {"w": w, "h": h}, depth+1, self, type)
	if objects != []:
		for object in objects:
			object.quadtree = null
			ne.insert(object) || nw.insert(object) || se.insert(object) || sw.insert(object)
		objects = []
	divided = true
	
func undivide(remains):
	if remains != null:
		objects = remains.objects
	ne = null
	nw = null
	se = null
	sw = null
	divided = false
	
func contains(spot):
	
	var x = spot.x - center.x
	if x < 0:
		x *= -1
	var y = spot.y - center.y
	if y < 0:
		y *= -1
	if x > boundary.w/2:
		
		return false
	if y > boundary.h/2:
		
		return false
	
	return true
	

func closest_to(potential, needs_los):
	if parent != null:
		return await ascend(potential, objects[0].global_position, {"object": null, "weight": 9999999999999999, "bound": totalbound}, self, needs_los)
	else:
		return null

func find(spot):
	if contains(spot):
		if !divided:
			return self
		else:
			var nefind = ne.find(spot)
			if nefind != null:
				return nefind
			var nwfind = nw.find(spot)
			if nwfind != null:
				return nwfind
			var sefind = se.find(spot)
			if sefind != null:
				return sefind
			var swfind = sw.find(spot)
			if swfind != null:
				return swfind
	else:
		return null

func closest(newpoint, potential, needs_los, from = null):
	if potential != {}:
		return {
			"object": potential.values()[0],
			"weight": 1000000,
			"bound": {
				
			}
		}
	else:
		return {
			"object": null
		}
	var homequad = find(newpoint)
	if from != type:
		if homequad.objects != []:
			for object in objects:
				if potential.has(object.id):
					return {
						"object": homequad.objects[0],
						"weight": newpoint.distance_squared_to(homequad.objects[0].global_position),
						"bound": {"w": homequad.objects[0].global_position.x - newpoint.x * 2, "h": homequad.objects[0].global_position.y - newpoint.y * 2}
					}
	var result = await homequad.ascend(potential, newpoint, {"object": null, "weight": 9999999999999999, "bound": totalbound}, homequad, needs_los)
	return result

func ascend(potential, newpoint, best, from, needs_los):
	if objects != []:
		var possible = false
		var options = []
		for object in objects:
			if potential.has(object.id):
				possible = true
				options.append(object)
		if possible && objects[0].global_position != newpoint:
			for i in options.size():
				var can = false
				if needs_los:
					#can = await options[i].has_los(newpoint)
					can = true
				else:
					can = true
				if can:
					var distance = newpoint.distance_squared_to(options[0].global_position)
					if distance < best.weight:
						var w = options[i].global_position.x - newpoint.x * 2
						if w < 0:
							w *= -1
						var h = options[i].global_position.y - newpoint.y * 2
						if h < 0:
							h *= -1
						if w > h:
							h = w
						else:
							w = h
						best.object = options[i]
						best.weight = distance
						best.bound = {"w": w, "h": h}
						pass
				else:
					pass
	if divided:
		if parent == null:
			pass
		if from != ne:
			ne.descend(potential, newpoint, best, needs_los)
		if from != nw:
			nw.descend(potential, newpoint, best, needs_los)
		if from != se:
			se.descend(potential, newpoint, best, needs_los)
		if from != sw:
			sw.descend(potential, newpoint, best, needs_los)
	if parent != null:
		return parent.ascend(potential, newpoint, best, self, needs_los)
	else:
		return best
	
func descend(potential, newpoint, best, needs_los):
	if intersects(best.bound, newpoint):
		if objects != []:
			for i in range(objects.size() - 1,-1,-1):
				if objects[i] == null:
					objects.pop_at(i)
		var i = 0
		if objects.size() > 0:
			i = randi() % objects.size()
		if divided:
			ne.descend(potential, newpoint, best, needs_los)
			nw.descend(potential, newpoint, best, needs_los)
			se.descend(potential, newpoint, best, needs_los)
			sw.descend(potential, newpoint, best, needs_los)
		elif objects != [] && objects[i].global_position != newpoint:
			var possible = false
			for object in objects:
				if potential.has(object.id):
					possible = true
			if possible:
				var can = false
				if needs_los:
					#can = await objects[i].has_los(newpoint)
					can = true
				else:
					can = true
				if can:
					var distance = newpoint.distance_squared_to(objects[0].global_position)
					if distance < best.weight:
						var w = objects[i].global_position.x - newpoint.x * 2
						if w < 0:
							w *= -1
						var h = objects[i].global_position.y - newpoint.y * 2
						if h < 0:
							h *= -1
						if w > h:
							h = w
						else:
							w = h
						best.object = objects[i]
						best.weight = distance
						best.bound = {"w": w, "h": h}
						pass
				else:
					pass
		return true
	else:
		return false
		
func check_for(object):
	pass

func intersects(bounds, intercenter):
	var iwest = intercenter.x - bounds.w/2
	var ieast = intercenter.x + bounds.w/2
	var isouth = intercenter.y - bounds.h/2
	var inorth = intercenter.y + bounds.h/2
	return iwest < west || ieast < east || isouth < south || inorth < north
	
	
func insert(object):
	if objects != [] && objects.find(object) != -1:
		object.quadtree = self
		return true
	if !contains(object.position):
		return false
	if objects == [] && !divided:
		objects = [object]
		object.quadtree = self
		return true
	elif !divided:
		var overlapping = false
		for i in range(objects.size()-1,-1,-1):
			if objects[i] == null:
				objects.pop_at(i)
			elif objects[i].global_position == object.global_position:
				objects.append(object)
				object.quadtree = self
				overlapping = true
				return true
		if !overlapping:
			await divide()
	return ne.insert(object) || nw.insert(object) || se.insert(object) || sw.insert(object)
	
func remove(object):
	var index = objects.find(object)
	if objects.size() > 0 && index != -1:
		objects.pop_at(index)
		if parent != null:
			parent.merge_check()
	else:
		if divided:
			ne.remove(object)
		if divided:
			nw.remove(object)
		if divided:
			se.remove(object)
		if divided:
			sw.remove(object)
	
func merge_check():
	if divided:
		if ne.merge_check() && nw.merge_check() && se.merge_check() && sw.merge_check():
			var pointcount = 0
			var remain
			if ne.objects != []:
				pointcount += 1
				remain = ne
			if nw.objects != []:
				pointcount += 1
				remain = nw
			if se.objects != []:
				pointcount += 1
				remain = se
			if sw.objects != []:
				pointcount += 1
				remain = sw
			if pointcount <= 1:
				if parent != null:
					undivide(remain)
				return true
		else:
			return false
	else:
		return true
	
func query(bounds, bcenter, found):
	if !intersects(bounds, bcenter):
		return false
		var loc = objects[0].position
		var has = true
		if loc.x * loc.x - center.x * center.x < boundary.w:
			has = false
		if loc.y * loc.y - center.y * center.y < boundary.h:
			has = false
		if has:
			found.append(objects[0])
	if divided:
		ne.query(bounds, bcenter, found)
		nw.query(bounds, bcenter, found)
		se.query(bounds, bcenter, found)
		sw.query(bounds, bcenter, found)
	return found
