extends Node

signal player_turn_finished
signal enemy_turn_finished
signal turn_passed
signal open_door
signal death_fog_finished
#signal player_turn_start

var death_fog_is_active:bool = false
var death_fog_overtime:bool = false
var turns_passed:int = 0
var turns_per_cycle:int = 3
var turns_per_day:int = turns_per_cycle * 3
var cycle_names_array:Array = ['Morning','Noon','Night']
var cycles_dictionary:Dictionary = {cycle_names_array[0]:turns_per_cycle, cycle_names_array[1]:turns_per_cycle, cycle_names_array[2]:turns_per_cycle}
var current_cycle_number:int = 0
var current_cycle = null
var dummy_turns_passed:int = 0 # this gets reset back to 0 every time a new cycle starts
var day:int
var day_over:bool = false

func _round_start() -> void:
	SignalManager.connect("entered_door",self,'stop_counting')
	change_cycle()
	
func emit_turn_passed() -> void:
	if day_over == false:
		emit_signal('turn_passed')
		turns_passed += 1
		dummy_turns_passed += 1
		if dummy_turns_passed >= turns_per_cycle:
			change_cycle()
			dummy_turns_passed = 0
		if turns_passed >= turns_per_day + 5:
			death_fog_overtime = true
		if SignalManager.debug_level > 1:
			print('----TURN PASSED---- ', turns_passed)

func player_turn_finished() -> void:
	emit_signal('player_turn_finished')

func enemy_turn_finished() -> void:
	emit_signal('enemy_turn_finished')

#func player_turn_start() -> void:
#	emit_signal('player_turn_start')

func change_cycle() -> void:
	if current_cycle_number < 3:
		current_cycle = cycle_names_array[current_cycle_number]
		current_cycle_number += 1
		turns_per_cycle = cycles_dictionary[cycle_names_array[current_cycle_number - 1]]
		print(current_cycle)
	else:
		death_fog_is_active = true
		emit_signal('open_door')

func emit_death_fog_finished(death_fog) -> void:
	emit_signal('death_fog_finished', death_fog)

func stop_counting() -> void:
	day_over = true
