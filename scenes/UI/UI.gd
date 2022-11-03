extends Control


onready var turn_label: Label = $turn_label
onready var speed_array_label: Label = $speed_array_label
onready var cycle_label: Label = $cycle_label

func _ready() -> void:
	SignalManager.connect("speed_array", self, 'update_speeds')

func _process(delta: float) -> void:
	turn_label.text = "Turns Passed = " + str(TurnManager.turns_passed)
	cycle_label.text = str(TurnManager.current_cycle, " : ", str(TurnManager.current_cycle_number))

func update_speeds(array) -> void:
	if array.size() > 0:
		speed_array_label.text = 'Order of Turns: ' + str(array[0].nametag)
