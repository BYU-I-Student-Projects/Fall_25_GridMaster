extends Card
class_name poison_bog

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 8)

func effect_two():
	GlobalSignal.emit_signal("relative_spawn_object", "poison_zone", 0, 10)

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 2)
