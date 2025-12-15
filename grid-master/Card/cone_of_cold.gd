extends Card
class_name cone_of_cold

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 6)

func effect_two():
	GlobalSignal.emit_signal("relative_spawn_object", "damage_zone", 0, 8)
	

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 1)
