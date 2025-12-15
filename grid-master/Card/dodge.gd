extends Card
class_name dodge

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 8)

func effect_two():
	GlobalSignal.emit_signal("player_add_value", 1, 1, 5)
	

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 1)
