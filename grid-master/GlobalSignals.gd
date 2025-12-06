extends Node

@warning_ignore_start("unused_signal")
signal player_add_value(playerID, valueID, value)
signal player_move(playerID, range)
signal free_move(objectID, X, Y)
# ObjectIDs: 1: player1, 2: player2, 3: Effect Zone (damage, healing, status, 
# etc), 10: Neutral Spawnable, 11: team1 Spawnable, 12: team2 Spawnable
# (add other objects' IDs as they're implemented.)
signal card_effect_finished(card_instance)
signal card_function_finished()
