class_name Card
extends Node2D

var card_id: String = ""

@export_node_path var btn1_path: NodePath = "Control/CardMoveButton"
@export_node_path var btn2_path: NodePath = "Control/CardActionButton"
@export_node_path var btn3_path: NodePath = "Control/CardResourceButton"
@export_node_path var shop_btn_path: NodePath = "Control/ShopButton"

func _ready() -> void:
	var btn1 = get_node(btn1_path) as Button
	var btn2 = get_node(btn2_path) as Button
	var btn3 = get_node(btn3_path) as Button
	var shop_btn = get_node(shop_btn_path) as Button

	# Connect signals to instance methods
	if btn1: btn1.pressed.connect(_on_button_action_1)
	if btn2: btn2.pressed.connect(_on_button_action_2)
	if btn3: btn3.pressed.connect(_on_button_action_3)

func _on_button_action_1() -> void:
	effect_one()
	GlobalSignal.emit_signal("card_in_use", self)
	await GlobalSignal.card_function_finished
	GlobalSignal.emit_signal("card_effect_finished", self)

func _on_button_action_2() -> void:
	effect_two()
	GlobalSignal.emit_signal("card_in_use", self)
	await GlobalSignal.card_function_finished
	GlobalSignal.emit_signal("card_effect_finished", self)

func _on_button_action_3() -> void:
	effect_three()
	GlobalSignal.emit_signal("card_in_use", self)
	await GlobalSignal.card_function_finished
	GlobalSignal.emit_signal("card_effect_finished", self)

func effect_one():
	pass

func effect_two():
	pass

func effect_three():
	pass

func set_shop_button():
	var btn1 = get_node(btn1_path) as Button
	var btn2 = get_node(btn2_path) as Button
	var btn3 = get_node(btn3_path) as Button
	var shop_btn = get_node(shop_btn_path) as Button
	if btn1: btn1.disabled = true
	if btn2: btn2.disabled = true
	if btn3: btn3.disabled = true
	if shop_btn: shop_btn.disabled = false

func set_play_buttons():
	var btn1 = get_node(btn1_path) as Button
	var btn2 = get_node(btn2_path) as Button
	var btn3 = get_node(btn3_path) as Button
	var shop_btn = get_node(shop_btn_path) as Button
	if btn1: btn1.disabled = false
	if btn2: btn2.disabled = false
	if btn3: btn3.disabled = false
	if shop_btn: shop_btn.disabled = true
