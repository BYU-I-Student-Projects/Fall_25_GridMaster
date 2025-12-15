extends Card
class_name blood_money

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 3)

func effect_two():
	GlobalSignal.emit_signal("relative_spawn_object", "damage_zone", 0, 8)
	

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 4)
