extends Node
class_name Player

var max_health := 100
var health := max_health

@onready var health_bar = $CanvasLayer/Health

func _ready():
	_update_health()

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):  # Space key
		apply_damage(10)
	elif Input.is_action_just_pressed("heal"):     # H key
		heal(10)

func apply_damage(amount: int):
	health = clamp(health - amount, 0, max_health)
	_update_health()

func heal(amount: int):
	health = clamp(health + amount, 0, max_health)
	_update_health()

func _update_health():
	health_bar.update_health(health, max_health)
