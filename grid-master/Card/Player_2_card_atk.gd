extends Card
class_name Player_2_atk_card

func effect_one():
	GlobalSignal.emit_signal("player_move", 2, 1)

func effect_two():
	GlobalSignal.emit_signal("player_add_value", 1, 2, 10)

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 2, 3, -2)
