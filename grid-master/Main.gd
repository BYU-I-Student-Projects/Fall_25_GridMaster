extends Node

@onready var death_message: Label = $Death_Message
var player_one_hand: Array = []
var player_one_discard_pile: Array = []
var player_two_hand: Array = []
var player_two_discard_pile: Array = []
var current_player_hand: Array = []
var current_player_discard_pile: Array = []
@onready var bottom_bar: HBoxContainer = $Deck/UI_Layer/Bottom_Bar
const CARDS_DIRECTORY = "res://Card/Card_Sence/"
var card_registry = {}
var current_player = 0
const CARD_SPACING = 10
const CARD_WIDTH = 160

func _ready() -> void:
	GlobalSignal.connect("card_effect_finished", _on_card_used)
	GlobalSignal.connect("deck_is_empty", deck_empty)
	GlobalSignal.connect("player_died", _on_player_died)
	
	card_registry = $Deck.load_card_classes(CARDS_DIRECTORY)
	
	current_player = 1
	current_player_start()
	
	print("Loaded card registry keys: ", card_registry.keys())
	start_of_round()
	print("Player's starting hand data: ", current_player_hand)

# --- NEW FUNCTION ---
func _on_player_died(playerID: int) -> void:
	death_message.text = "Player %d has died!" % playerID
	death_message.visible = true

func current_player_start():
	if current_player == 1:
		current_player_hand = player_one_hand
		current_player_discard_pile = player_one_discard_pile
		print("player one's turn")
		print("At Start:")
		print("Hand:", current_player_hand)
		print("Discard pile:", current_player_discard_pile)
		return
	
	if current_player == 2:
		current_player_hand = player_two_hand
		current_player_discard_pile = player_two_discard_pile
		print("player two's turn")
		print("At Start:")
		print("Hand:", current_player_hand)
		print("Discard pile:", current_player_discard_pile)
		return
	
	else:
		print("Error with Current Player Variable.")
		return

func start_of_round():
	var cards_in_hand = current_player_hand.size()
	var cards_to_draw = 3 - cards_in_hand
	if cards_to_draw != 3:
		for x in current_player_hand:
			print(x)
			load_card_into_container(x)
		draw_hand(cards_to_draw)
	else:
		draw_hand(cards_to_draw)

func draw_hand(cards_to_draw: int):
	print("starting to draw cards")
	for x in range(cards_to_draw):
		var new_card_data = $Deck.draw_card()
		if new_card_data != null:
			current_player_hand.append(new_card_data)
			load_card_into_container(new_card_data) 



func load_card_into_container(card_name: String):
	var card_scene_resource = card_registry.get(card_name)
	if card_scene_resource and card_scene_resource is PackedScene:
		var card_instance = card_scene_resource.instantiate()
		
		bottom_bar.add_child(card_instance)
		print("Total children in bottom_bar: ", bottom_bar.get_child_count())
		
		arrange_cards_manually()
		
		print("Successfully added '%s' to bottom_bar." % card_name)
	else:
		print("Error: Could not find a valid PackedScene for '%s'." % card_name)


func arrange_cards_manually():
	var current_x_offset = 0
	
	for card in bottom_bar.get_children():
		card.position.x = current_x_offset
		current_x_offset += CARD_WIDTH + CARD_SPACING

func _on_card_used(card):
	if card != null:
		var full_path = card.scene_file_path
		var file_name = full_path.get_file()
		var basename = file_name.get_basename()
		var index_to_remove = current_player_hand.find(basename)
		if index_to_remove != -1:
			current_player_hand.erase(current_player_hand[index_to_remove])
			print("Hand:", current_player_hand)
		
		current_player_discard_pile.append(basename)
		print("Discard Pile:", current_player_discard_pile)

func deck_empty():
	var draw_pile = current_player_discard_pile
	print(draw_pile)
	$Deck.deck_is_empty(draw_pile)
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Deck/shop.tscn")
