extends Control


onready var turn_label: Label = $turn_label
onready var cycle_label: Label = $cycle_label
onready var options_menu: Control = $"%options menu"
onready var player: KinematicBody2D = $"%player"


func _ready() -> void:
# warning-ignore:return_value_discarded
	SignalManager.connect("turn_time", self, 'update_test_label')
	options_menu.hide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and options_menu.visible == false:
		get_tree().paused = true
		options_menu.show()
	elif event.is_action_pressed("escape") and options_menu.visible == true:
		options_menu.hide()
		get_tree().paused = false
		
		
func _process(_delta: float) -> void:
	turn_label.text = "Turns Passed = " + str(TurnManager.turns_passed)
	cycle_label.text = str(TurnManager.current_cycle, " : ", str(TurnManager.current_cycle_number))

func update_test_label(x,y) -> void:
	$"%test_label".text = str(x, ' ', y)

func convert_to_nametags(entity_array) -> Array:
	var new_array:Array = []
	for i in entity_array:
		new_array.append(i.nametag)
	return new_array
