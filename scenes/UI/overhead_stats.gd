extends Control

onready var parent = get_parent()
onready var hp_label: Label = $stats/hp_label
onready var spd_label: Label = $stats/spd_label
onready var def_label: Label = $stats/def_label
onready var dmg_label: Label = $stats/dmg_label
onready var name_label: Label = $stats/name_label
onready var remove_timer: Timer = $remove_timer

func _ready() -> void:
	SignalManager.connect("mouse_left_target_area", self, 'remove')
	SignalManager.connect("mouse_entered_target_area",self, 'cancel_remove')
	TurnManager.connect("enemy_turn_finished", self, 'hard_remove')
	self.rect_position = parent.overhead_stats_position.position
	update_stats()

func _process(delta: float) -> void:
	update_stats()

func update_stats() -> void:
	parent.has_overhead_stats = true
	name_label.text = str(parent.stats.nametag)
	if parent.is_in_group('enemy'):
		hp_label.text = "hp:" + str(parent.hp) + '/' + str(parent.stats.base_hp)
		spd_label.text = 'spd:' + str(parent.speed)
	if parent.is_in_group('player'):
		hp_label.text = "hp:" + str(parent.stats.hp)
		spd_label.text = 'spd:'+ str(parent.stats.speed)
	
func remove(target) -> void:
	if target == parent:
		remove_timer.start(0.5)
		yield(remove_timer, "timeout")
		parent.has_overhead_stats = false
		queue_free()

func hard_remove() -> void:
	queue_free()
		
func cancel_remove(target) -> void:
	if target == get_parent():
		remove_timer.stop()
