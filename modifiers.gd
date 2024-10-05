extends Object
class_name Modifiers

var mods = {}

func clear():
	mods = {}

func ret(modname):
	if !mods.has(modname):
		return 0
	else:
		return mods[modname]
		
func mod(modname, amount):
	if mods.has(modname):
		mods[modname] += amount
	else:
		mods.merge({
			modname: amount
		})
	if mods[modname] == 0:
		mods.erase(modname)
