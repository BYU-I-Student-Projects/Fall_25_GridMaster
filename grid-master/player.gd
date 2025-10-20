extends Node
class_name Player

var max_health := 100
var health := max_health
var pID := 1
var resource_count := 0

@onready var health_bar = $CanvasLayer/HealthBar

func _ready():
	_update_health()
	PlayerAddValue.connect("player_add_value", self._on_player_add_value)

func _on_player_add_value(playerID, valueID, value):
	if (playerID == pID):
		if (valueID == 1):
			heal(value)
		elif (valueID == 2):
			resource_count += value
			print(resource_count)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):  # Space key
		apply_damage(10)

func apply_damage(amount: int):
	health = clamp(health - amount, 0, max_health)
	_update_health()

func heal(amount: int):
	health = clamp(health + amount, 0, max_health)
	_update_health()

func _update_health():
	health_bar.update_health(health, max_health)
