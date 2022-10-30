extends Node

signal console_label
signal mouse_entered_target_area
signal mouse_left_target_area
signal enemy_died
signal speed_array

func emit_console_label(text, color) -> void:
	emit_signal('console_label', text, color)

func emit_mouse_entered_target_area(target) -> void:
	emit_signal('mouse_entered_target_area', target)

func emit_mouse_left_target_area(target) -> void:
	emit_signal('mouse_left_target_area', target)

func emit_enemy_died(enemy) -> void:
	emit_signal('enemy_died', enemy)

func emit_speed_array_info(array) -> void:
	emit_signal('speed_array', array)