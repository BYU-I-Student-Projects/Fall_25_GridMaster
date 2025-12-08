extends Card
class_name atk_card

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 9)

func effect_two():
	GlobalSignal.emit_signal("player_add_value", 2, 2, 10)

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, -2)
