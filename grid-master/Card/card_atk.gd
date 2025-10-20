extends Card
class_name atk_card

func effect_one():
	print("Move Action")

func effect_two():
	PlayerAddValue.emit_signal("player_add_value", 1, 2, 10)

func effect_three():
	PlayerAddValue.emit_signal("player_add_value", 1, 3, -2)
