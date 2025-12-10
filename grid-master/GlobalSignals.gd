extends Node

@warning_ignore_start("unused_signal")
signal player_move(playerID, range)

signal card_effect_finished(card_instance)
signal card_function_finished()
signal deck_is_empty()
signal move_at(X, Y, DX, DY)
signal object_move(objectIDs, range)
signal relative_spawn_object(object, ownership, move_pattern)
signal spawn_object(object, ownership, X, Y)
# Object should be used to create a specific object
# Ownership 0 = Neutral, 1 = Player1, 2 = Player2

signal free_move(objectID, X, Y)
# ObjectIDs: 1: player1, 2: player2, 3: Effect Zone (damage, healing, status, 
# etc), 10: Neutral Spawnable, 11: team1 Spawnable, 12: team2 Spawnable
# (add other objects' IDs as they're implemented.)

signal spawn_effect_zone(effectID, X, Y, magnitude, duration)
signal player_add_value(playerID, effectID, value)
# EffectIDs: 1: Heal, 2: Damage, 3: Resource Gain, 4: Resource Loss
