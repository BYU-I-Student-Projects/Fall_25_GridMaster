extends Card
class_name 

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 6)

func effect_two():
	GlobalSignal.emit_signal("", )

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 2)
