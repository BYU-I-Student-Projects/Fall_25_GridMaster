extends Card
class_name test_card_Spawning_and_Movement

# spawn object
func effect_one():
	GlobalSignal.emit_signal("relative_spawn_object", "wall", 1, 1)

# move object
func effect_two():
	GlobalSignal.emit_signal("object_move", [2, 10], 1)

# create attack zone
func effect_three():
	GlobalSignal.emit_signal("spawn_effect_zone", "damage_zone", 1, 1, 1)
