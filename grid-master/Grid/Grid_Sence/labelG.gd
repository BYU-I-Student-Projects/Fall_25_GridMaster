extends Label

var resource = 0
func _ready():
	text = str(resource)
	GlobalSignal.connect("player_add_value", self._add_value)

func _add_value(playerID, valueID, value):
	if (playerID == 1):
		if (valueID == 3):
			resource += value
			text = str(resource)
