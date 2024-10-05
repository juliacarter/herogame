extends Object
class_name Targeter

var targets = []

#Fired when the player starts targeting things
var primefunc = ""
var primeargs = []

#Fired when the player tries to select something
var targetfunc = ""
var targetargs = []

func _init(data):
	if data.has("primefunc"):
		primefunc = data.primefunc
	if data.has("targetfunc"):
		targetfunc = data.targetfunc
