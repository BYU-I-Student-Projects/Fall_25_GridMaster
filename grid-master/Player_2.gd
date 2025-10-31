extends Node
class_name Player_2

var max_health := 100
var health := max_health
var pID := 2
var resource_count := 0

func _ready():
	GlobalSignal.connect("player_add_value", self._on_player_add_value)

func _on_player_add_value(playerID, valueID, value):
	if playerID == pID:
		if (valueID == 1):
			heal(value)
		if valueID == 2:
			apply_damage(value)
		elif valueID == 3:
			resource_count += value
			print("Player 2 resource changed by %d → Total: %d" % [value, resource_count])

func apply_damage(amount: int):
	health = clamp(health - amount, 0, max_health)
	print("Player 2 took %d damage! Health is now %d" % [amount, health])

func heal(amount: int):
	health = clamp(health + amount, 0, max_health)
	print("Player 2 heal %d health is now %d" % [amount,health])
