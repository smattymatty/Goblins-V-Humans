extends Control

onready var debug_level: Label = $"%debug_level"
onready var debug_slider: HSlider = $"%debug_slider"
onready var time_btwn_turns: Label = $"%time_btwn_turns"
onready var time_btwn_turns_slider: HSlider = $"%time_btwn_turns_slider"
onready var goblin_spawn_button: Button = $"%goblin_spawn_button"
onready var human_spawn_button: Button = $"%human_spawn_button"

func _ready() -> void:
	debug_level.text  = 'debug_level ('+str(SignalManager.debug_level)+') '
	debug_slider.value = SignalManager.debug_level
	time_btwn_turns.text = 'time between turns ('+str(SignalManager.time_between_turns)+')'
	time_btwn_turns_slider.value = SignalManager.time_between_turns

func _on_debug_slider_value_changed(value: float) -> void:
	SignalManager.debug_level = value
	debug_level.text  = 'debug_level ('+str(SignalManager.debug_level)+') '


func _on_time_btwn_turns_slider_value_changed(value: float) -> void:
	SignalManager.time_between_turns = value
	time_btwn_turns.text = 'time between turns ('+str(SignalManager.time_between_turns)+')'



func _on_goblin_spawn_button_pressed() -> void:
	SignalManager.emit_spawn_goblin()
	
func _on_human_spawn_button_pressed() -> void:
	SignalManager.emit_spawn_human()
