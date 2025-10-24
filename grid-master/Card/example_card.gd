extends Card

class_name Example_Card

func effect_one():
	print("Move Action")
	PlayerAddValue.emit_signal("move_player", 1)

func effect_two():
	PlayerAddValue.emit_signal("player_add_value", 1, 1, 10)

func effect_three():
	PlayerAddValue.emit_signal("player_add_value", 1, 3, 2)
