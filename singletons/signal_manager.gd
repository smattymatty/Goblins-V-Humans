extends Node

signal console_label
signal mouse_entered_target_area
signal mouse_left_target_area
signal enemy_died
signal speed_array
signal overhead_stats
signal hard_remove_overhead_stats
signal spawn_goblin
signal spawn_human
signal entered_door
signal moved_up
signal update_time_to_move

var debug_level = 5
var time_between_turns = 0.0

func emit_console_label(text, color) -> void:
	emit_signal('console_label', text, color)

func emit_mouse_entered_target_area(target) -> void:
	emit_signal('mouse_entered_target_area', target)

func emit_mouse_left_target_area(target) -> void:
	emit_signal('mouse_left_target_area', target)

func emit_enemy_died(enemy) -> void:
	emit_signal('enemy_died', enemy)
	SignalManager.emit_console_label(str(enemy.nametag) + ' has died!', Color.red)
	
func emit_speed_array(sorted_entities) -> void:

	emit_signal("speed_array", sorted_entities)
	
func emit_update_time_to_move(entities) -> void:
	emit_signal("update_time_to_move", entities)

func emit_overhead_stats(target, instance) -> void:
	emit_signal('overhead_stats', target, instance)

func emit_hard_remove_overhead_stats(target) -> void:
	emit_signal('hard_remove_overhead_stats',target)

func emit_spawn_goblin() -> void:
	emit_signal('spawn_goblin')
	
func emit_spawn_human() -> void:
	emit_signal('spawn_human')
	
func emit_entered_door() -> void:
	emit_signal('entered_door')

func emit_moved_up() -> void:
	emit_signal('moved_up')
