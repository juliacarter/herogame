extends Task
class_name TalkTask


var talktime = 5

var conversation

func _init(convo):
	conversation = convo
	target = conversation.conversation_point
