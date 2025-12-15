extends Card
class_name heal

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 5)

func effect_two():
	GlobalSignal.emit_signal("player_add_value", 1, 20)

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 1)
