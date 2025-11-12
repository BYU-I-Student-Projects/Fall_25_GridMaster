extends Node
class_name Player

var max_health := 100
var health := max_health
var pID := 1
var resource_count := 0
var turntimer := 0

@onready var health_bar = $CanvasLayer/HealthBar

func _status_effect(status):
	if status == "poison":
		#player takes gradual damage for a few turns.
		apply_damage(10)
		if turntimer == 0:
			turntimer += 1
		elif turntimer == 1:
			turntimer += 1
		elif turntimer == 2:
			turntimer = 0
			#cure status here.
	elif status == "freeze":
		#player cant use one card for one turn. Card is discarded next turn.
		apply_damage(10)
	elif status == "burn":
		#player deals less damage for a few turns.
		apply_damage(10)
		if turntimer == 0:
			turntimer += 1
		elif turntimer == 1:
			turntimer += 1
		elif turntimer == 2:
			turntimer = 0
			#cure status here.
	elif status == "regen":
		#player gradually heals for a few turns.
		heal(10)
		if turntimer == 0:
			turntimer += 1
		elif turntimer == 1:
			turntimer += 1
		elif turntimer == 2:
			turntimer = 0
			#cure status here.
	elif status == "shock":
		#player cannot move for a turn.
		apply_damage(10)
	else:
		print("Status does not exist.")

func _ready():
	_update_health()
	GlobalSignal.connect("player_add_value", self._on_player_add_value)

func _on_player_add_value(playerID, valueID, value):
	if (playerID == pID):
		if (valueID == 1):
			heal(value)
		elif (valueID == 2):
			apply_damage(value)
		elif (valueID == 3):
			resource_count += value
			print(resource_count)

func apply_damage(amount: int):
	health = clamp(health - amount, 0, max_health)
	_update_health()

func heal(amount: int):
	health = clamp(health + amount, 0, max_health)
	_update_health()

func _update_health():
	health_bar.update_health(health, max_health)
