extends Node2D
class_name object

var ownership
var health
var tileID

func initialize(ownerID: int) -> void:
	ownership = ownerID

# Need signals for these
func apply_damage(amount: int):
	_update_health(amount)

func heal(amount: int):
	_update_health(-amount)

func _update_health(amount):
	health += amount
	# Manage floating health digit
	pass
