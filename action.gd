extends Object
class_name Action

#Play these when the unit performs action
var visuals = []

#Chance to pop up these sound bubbles when performing this action
var bubbles = []

#Unit does this when performing this action
var animation = ""

func _init(gamedata, actiondata):
	if actiondata.has("visuals"):
		for visdata in actiondata.visuals:
			if gamedata.visual_effects.has(visdata.name):
				var anim = gamedata.visual_effects[visdata.name]
				visdata.merge({
					"visual": anim
				})
				var vis = ActionVisual.new(visdata)
				visuals.append(vis)
	if actiondata.has("animation"):
		animation = actiondata.animation
	if actiondata.has("bubbles"):
		for bubbledata in actiondata.bubbles:
			var bubble = SoundBubbleData.new(bubbledata)
			bubbles.append(bubble)

#Extend this
func fire(target):
	pass
