extends Node

var player_hand: Array = []
@onready var bottom_bar: HBoxContainer = $Deck/UI_Layer/Bottom_Bar

# Make sure this path points to a Tscn file that uses the CardBase.gd script
const CardSceneTemplate = preload("res://Card/Card_Sence/card.tscn") 

func _ready() -> void:
	draw_starting_hand(3)
	print("Player's starting hand data: ", player_hand)

func draw_starting_hand(cards_to_draw: int):
	print("starting to draw cards")
	for x in range(cards_to_draw):
		var new_card_data = $Deck.draw_card() # e.g., "card_atk1"

		if new_card_data != null:
			player_hand.append(new_card_data)

			# 1. Instantiate the visual card scene (which uses CardBase.gd)
			var card_instance = CardSceneTemplate.instantiate()
			
			card_instance.initialize_card(new_card_data)

			
			# 2. Add it to the HBoxContainer
			bottom_bar.add_child(card_instance)
			
			print("card added below")
