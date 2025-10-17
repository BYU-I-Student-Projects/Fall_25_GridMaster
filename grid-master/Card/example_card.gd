extends Card

class_name Example_Card

func effect_one():
	print("Move Action")

func effect_two():
	PlayerAddValue.emit_signal("player_add_value", 1, 1, 10)

func effect_three():
	print("Resources++")
