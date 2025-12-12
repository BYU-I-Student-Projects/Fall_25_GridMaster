extends Card
class_name fire_pillar

func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 1)

func effect_two():
	GlobalSignal.emit_signal("spawn_effect_zone", 2, -1, -1, 5, 2)
	# Need to make an or X, Y of -1 allow user to select any valid value in that row/column/both

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, 4)
