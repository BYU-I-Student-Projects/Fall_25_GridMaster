extends Label

func _ready():
	GlobalSignal.connect("player_died", self._end)

func _end(playerID):
	print("AAAA")
	text = "Player " + str(playerID) + " has died"
