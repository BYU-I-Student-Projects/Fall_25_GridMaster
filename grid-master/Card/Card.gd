# CardBase.gd
class_name Card
extends Node2D

var card_id: String = ""

@export_node_path var btn1_path: NodePath = "Control/CardMoveButton"
@export_node_path var btn2_path: NodePath = "Control/CardActionButton"
@export_node_path var btn3_path: NodePath = "Control/CardResourceButton"

func _ready() -> void:
	pass

func initialize_card(data_id: String) -> void:
	self.card_id = data_id # Set the ID here

	# Get the node reference dynamically
	var card_name_label: Label = get_node("CardName")
	
	if card_name_label != null:
		card_name_label.text = card_id 

	print("My ID is now set to: ", card_id)

	var btn1 = get_node(btn1_path) as Button
	var btn2 = get_node(btn2_path) as Button
	var btn3 = get_node(btn3_path) as Button

	# Connect signals to instance methods
	if btn1: btn1.pressed.connect(_on_button_action_1)
	if btn2: btn2.pressed.connect(_on_button_action_2)
	if btn3: btn3.pressed.connect(_on_button_action_3)

# Default handlers that subclasses can override
func _on_button_action_1() -> void:
	effect_one()

func _on_button_action_2() -> void:
	effect_two()

func _on_button_action_3() -> void:
	effect_three()

# "Virtual" action methods intended to be overridden
func effect_one():
	GlobalSignal.emit_signal("player_move", 1, 1)

func effect_two():
	GlobalSignal.emit_signal("player_add_value", 2, 2, 10)

func effect_three():
	GlobalSignal.emit_signal("player_add_value", 1, 3, -2)
