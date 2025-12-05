extends Node

var player_hand: Array = []
var discard_pile = []
@onready var bottom_bar: HBoxContainer = $Deck/UI_Layer/Bottom_Bar
const CARDS_DIRECTORY = "res://Card/Card_Sence/"
var card_registry = {}

const CARD_SPACING = 20
const CARD_WIDTH = 160

func _ready() -> void:
	card_registry = $Deck.load_card_classes(CARDS_DIRECTORY)
	
	GlobalSignal.connect("player_add_value", self._on_card_used)
	GlobalSignal.connect("player_move", self._on_card_used)
	GlobalSignal.connect("free_move", self._on_card_used)
	
	
	print("Loaded card registry keys: ", card_registry.keys())
	draw_starting_hand(3)
	print("Player's starting hand data: ", player_hand)

func draw_starting_hand(cards_to_draw: int):
	print("starting to draw cards")
	for x in range(cards_to_draw):
		var new_card_data = $Deck.draw_card()

		if new_card_data != null:
			player_hand.append(new_card_data)
			
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

func _on_card_used(card_node: Node2D):

	discard_pile.append(card_node.name)
	
	card_node.queue_free()
	
	arrange_cards_manually()
	
	print("Current discard pile size: ", discard_pile.size())
