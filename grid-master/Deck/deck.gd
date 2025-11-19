class_name Deck
extends Node2D

# This is the master list of all cards in the correct order/set.
var player_deck = ["card_atk", "card_atk", "card_atk", "card_atk", "card_atk", "card_atk"]

# This array will act as your active draw pile.
var draw_pile: Array = []


func _ready() -> void:
	draw_pile = player_deck.duplicate() # This duplicates the player deck
	draw_pile.shuffle() # This shuffles the draw pile
	print("Original master deck (untouched): ", player_deck)
	print("Shuffled draw pile: ", draw_pile)


func draw_card():
	# Check the draw_pile, not random_player_deck
	if draw_pile.is_empty():
		print("Cannot draw, the deck is empty!")
		return null 
	else:
		var drawn_card = draw_pile.pop_front()
		
		print("You drew: ", drawn_card)
		print("Cards remaining in pile: ", draw_pile)
		
		return drawn_card
