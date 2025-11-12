extends Node

@warning_ignore("unused_signal")
signal player_add_value(playerID, valueID, value)
@warning_ignore("unused_signal")
signal player_move(playerID, range)

@warning_ignore("unused_signal")
signal free_move(objectID, X, Y)
# ObjectIDs: 1: player1, 2: player2, (add other objects' IDs as they're implemented.)
