extends Control


onready var turn_label: Label = $turn_label
onready var speed_array_label: Label = $speed_array_label

func _ready() -> void:
	SignalManager.connect("speed_array", self, 'update_speeds')

func _process(delta: float) -> void:
	turn_label.text = "Turns Passed = " + str(TurnManager.turns_passed)

func update_speeds(array) -> void:
	speed_array_label.text = 'Order of Turns: ' + str(array)
