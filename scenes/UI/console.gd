extends Control

onready var scroll_container: ScrollContainer = $ScrollContainer
onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer

func _ready() -> void:
	SignalManager.connect("console_label",self,'create_label')

func create_label(text_given, color) -> void:
	var console_label = load("res://scenes/UI/console_label.tscn")
	var console_label_instance = console_label.instance()
	console_label_instance.text = text_given
	console_label_instance.modulate = color
	console_label_instance.set_turn(TurnManager.turns_passed)
	v_box_container.add_child(console_label_instance)
	yield(get_tree().create_timer(0.01), "timeout")
	scroll_container.scroll_vertical += 999
	

	
