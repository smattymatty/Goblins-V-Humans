class_name CharacterOld
extends Node2D

var STATE
var PREV_STATE
var turn_to_move = false
var last_moved_direction
var has_overhead_stats = false
var on_death_fog = false
var fog_multiplier:float = 1.0
var nametag

onready var raycast_down: RayCast2D = $"Raycast DOWN"
onready var raycast_up: RayCast2D = $"Raycast UP"
onready var raycast_right: RayCast2D = $"Raycast RIGHT"
onready var raycast_left: RayCast2D = $"Raycast LEFT"
onready var animation: AnimationPlayer = $AnimationPlayer
onready var target_indicator: Sprite = $target_indicator
onready var target_collision: CollisionShape2D = $target_area/CollisionShape2D
onready var overhead_stats_position: Position2D = $overhead_stats_position
onready var debug_label: Label = $"%debug_label"


enum STATES {
	FREE, NOT_FREE, IN_COMBAT, STUNNED
}

func _ready() -> void:
	debug_label.hide()
	target_indicator.hide()
	
func _process(delta: float) -> void:
	if SignalManager.debug_level > 3 and self.is_in_group('death fog') != true:
		debug_label.show()
		debug_label.text = str(STATE)
	if target_indicator.visible == true and has_overhead_stats == false:
		yield(get_tree().create_timer(1.0),'timeout')
		if target_indicator.visible == true and has_overhead_stats == false:
			instance_overhead_stats(self)
			has_overhead_stats = true
	if target_indicator.visible == false and has_overhead_stats == true:
		SignalManager.emit_hard_remove_overhead_stats(self)
		has_overhead_stats = false

func set_state(new_state) -> void:
	PREV_STATE = STATE
	STATE = new_state

func _on_target_area_area_entered(area: Area2D) -> void:
	if self.is_in_group('death fog') == false:
		target_indicator.show()
		SignalManager.emit_mouse_entered_target_area(self)
		area.mouseover_timer.start(0.5)
		yield(area.mouseover_timer,'timeout')
		instance_overhead_stats(self)

func _on_target_area_area_exited(area: Area2D) -> void:
	area.mouseover_timer.stop()
	target_indicator.hide()
	SignalManager.emit_mouse_left_target_area(self)
	
func instance_overhead_stats(target) -> void:
	var overhead_stats = load("res://scenes/UI/overhead_stats.tscn")
	var overhead_stats_instance = overhead_stats.instance()
	overhead_stats_instance.rect_position = target.overhead_stats_position.position
	overhead_stats_instance.target = target
	overhead_stats_instance.update_stats(target)
	SignalManager.emit_overhead_stats(target, overhead_stats_instance)
	
func shuffle_grab(array,index):
	randomize()
	array.shuffle()
	return array[index]
