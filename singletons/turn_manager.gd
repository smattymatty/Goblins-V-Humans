extends Node

signal player_turn_finished
signal enemy_turn_begin
signal enemy_turn_finished
#signal player_turn_start

var turns_passed = 0



func _ready() -> void:
	pass

func player_turn_finished() -> void:
	emit_signal('player_turn_finished')
	turns_passed += 1

func enemy_turn_finished() -> void:
	emit_signal('enemy_turn_finished')

#func player_turn_start() -> void:
#	emit_signal('player_turn_start')
