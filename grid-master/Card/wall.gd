extends Card
class_name card_wall

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 3)

func effect_two():
	GlobalSignal.emit_signal("relative_spawn_object", "wall", 0, 10)
	

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 2)
