extends Object
#Controls values for each Class on a per faction basis
class_name ClassController

var controlled_class

var faction

#The amount of this class controlled by the faction
var count = 0

#The amount desired by the faction
#If lower than count, order more of this class
var desired = 0

#Classes that can be converted into this Class, by key
var usable_classes = []

#Clearances provided to this Class by the faction
var clearances = []

#Units of the controlled class belonging to this faction, by ID
var units = {}
