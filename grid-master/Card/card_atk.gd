extends Card
class_name atk_card

func effect_one():
	PlayerAddValue.emit_signal("player_move", 1, 1)

func effect_two():
	PlayerAddValue.emit_signal("player_add_value", 1, 1, -10)

func effect_three():
	PlayerAddValue.emit_signal("player_add_value", 1, 3, -2)
