class_name Character
extends Node2D

var turn_to_move = false
var last_moved_direction
var has_overhead_stats = false

onready var raycast_down: RayCast2D = $"Raycast DOWN"
onready var raycast_up: RayCast2D = $"Raycast UP"
onready var raycast_right: RayCast2D = $"Raycast RIGHT"
onready var raycast_left: RayCast2D = $"Raycast LEFT"
onready var animation: AnimationPlayer = $AnimationPlayer
onready var target_indicator: Sprite = $target_indicator
onready var overhead_stats_position: Position2D = $overhead_stats_position


func _ready() -> void:
	target_indicator.hide()




func _on_target_area_area_entered(area: Area2D) -> void:
	target_indicator.show()
	SignalManager.emit_mouse_entered_target_area(self)


func _on_target_area_area_exited(area: Area2D) -> void:
	target_indicator.hide()
	SignalManager.emit_mouse_left_target_area(self)
