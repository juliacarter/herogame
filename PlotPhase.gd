extends Object
class_name PlotPhase

#Furniture that must be built for this Phase
var furniture = []


#Quests that must be completed to progress the Phase
#can be done in any order
var quests = []

#Number of Phase Quests that need to be completed
#by default, all of them
var quest_count = 0

#Unlocks from starting the Phase
var unlocks = {}

#Global effects added upon starting Phase
var phase_effects = []
