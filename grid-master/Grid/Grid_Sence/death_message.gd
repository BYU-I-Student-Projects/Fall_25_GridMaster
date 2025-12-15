extends Label

func _ready() -> void:
	# Connect to the global signal once
	add_theme_font_size_override("font_size", 48)
	GlobalSignal.connect("player_died", Callable(self, "_on_player_died"))

func _on_player_died(player_id: int) -> void:
	if player_id == 1:
		text = "Player 1 has died!"
	elif player_id == 2:
		text = "Player 2 has died!"
