extends Card
class_name Temp_Card_Opponent2

func effect_one():
	GlobalSignal.emit_signal("player_move", 2, 1)

func effect_two():
	GlobalSignal.emit_signal("player_add_value", 2, 1, 10)

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 2, 3, 2)
