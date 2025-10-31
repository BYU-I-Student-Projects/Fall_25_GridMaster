extends Card
class_name Example_Card

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 1)

func effect_two():
	GlobalSignal.emit_signal("player_add_value", 1, 1, 10)

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 2)
