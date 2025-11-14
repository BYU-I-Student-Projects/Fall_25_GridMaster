extends Node

@warning_ignore("unused_signal")
signal player_add_value(playerID, valueID, value)
@warning_ignore("unused_signal")
signal player_move(playerID, range)
@warning_ignore("unused_signal")
signal free_move(objectID, X, Y)
# ObjectIDs: 1: player1, 2: player2, 3: Effect Zone (damage, healing, status, 
# etc), 10: Neutral Spawnable, 11: team1 Spawnable, 12: team2 Spawnable
# (add other objects' IDs as they're implemented.)
