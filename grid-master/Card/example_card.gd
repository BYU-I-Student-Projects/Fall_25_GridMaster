extends Card

class_name Example_Card

func effect_one():
	print("Move Action")
	PlayerAddValue.emit_signal("move_player", 1)

func effect_two():
	print("HP++")

func effect_three():
	print("Resources++")
