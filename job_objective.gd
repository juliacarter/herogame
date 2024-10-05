extends Objective
class_name JobObjective

var jobdata

var completions = 0
var needed = 1

func status_function():
	return completions >= needed
