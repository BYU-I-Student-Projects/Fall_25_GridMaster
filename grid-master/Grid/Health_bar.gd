extends ProgressBar

@onready var damage_bar = $DamageBar

@onready var timer = $Timer

var health := 0

func _ready():
	value = health
	damage_bar.value = health

func update_health(current: int, max_health: int) -> void:
	var previous = health
	health = clamp(current, 0, max_health)
	max_value = max_health
	value = health
	damage_bar.max_value = max_health

	if health <= 0:
		queue_free()

	if health < previous:
		timer.start()
	else:
		damage_bar.value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
