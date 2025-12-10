extends Node
class_name Player_2

var max_health := 100
var health := max_health
var pID := 2
var resource_count := 0
var turntimer := [0,0,0,0,0]
enum status{POISON,FREEZE,BURN,REGEN,SHOCK}

func _ready():
	GlobalSignal.connect("player_add_value", self._on_player_add_value, CONNECT_DEFERRED)

func _status_effect():
	for i in turntimer:
		
		if status[i] == status.POISON:
			#player takes gradual damage for a few turns.
			if turntimer[0] > 0:
				apply_damage(10)
				
		if status[i] == status.FREEZE:
			#player cant use one card for one turn. Card is discarded next turn.
			if turntimer[i] > 0:
				apply_damage(10)
			
		if status[i] == status.BURN:
			#player deals less damage for a few turns.
			if turntimer[i] > 0:
				apply_damage(10)
				
		if status[i] == status.REGEN:
			#player gradually heals for a few turns.
			if turntimer[i] > 0:
				heal(20)
				
		if status[i] == status.SHOCK:
			#player cannot move for a turn.
			if turntimer[i] > 0:
				apply_damage(10)

		if turntimer[i] > 1:
			turntimer[i] -= 1


func _on_player_add_value(playerID, valueID, value):
	if playerID == pID:
		if (valueID == 1):
			heal(value)
		if valueID == 2:
			apply_damage(value)
		elif valueID == 3:
			resource_count += value
			print("Player 2 resource changed by %d → Total: %d" % [value, resource_count])
		GlobalSignal.emit_signal("card_function_finished")

func apply_damage(amount: int):
	health = clamp(health - amount, 0, max_health)
	print("Player 2 took %d damage! Health is now %d" % [amount, health])

func heal(amount: int):
	health = clamp(health + amount, 0, max_health)
	print("Player 2 heal %d health is now %d" % [amount,health])
