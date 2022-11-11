extends Control


var location
var target
var scroll_finished:bool = false

onready var hp_label: Label = $"%hp_label"
onready var spd_label: Label = $"%spd_label"
onready var def_label: Label = $"%def_label"
onready var dmg_label: Label = $"%dmg_label"
onready var name_scroll_bar: ScrollContainer = $"%name_scroll_bar"
onready var name_label: Label = $"%name_label"
onready var scroll_timer: Timer = $"%scroll_timer"
onready var remove_timer: Timer = $"%remove_timer"
onready var update_timer: Timer = $"%update_timer"


func _ready() -> void:
	SignalManager.connect("mouse_left_target_area", self, 'remove')
	SignalManager.connect("mouse_entered_target_area",self, 'cancel_remove')
	SignalManager.connect("hard_remove_overhead_stats", self, 'hard_remove')
	update_timer.connect('timeout',self,'_update_timer_tick')
	scroll_timer.start(2.0)

func _update_timer_tick() -> void:
	if is_instance_valid(target):
		update_stats(target)

func update_stats(target) -> void:
#	self.rect_position = target.overhead_stats_position.global_position
	target.has_overhead_stats = true
	$"%name_label".text = str(target.nametag)
	if target.is_in_group('enemy'):
		$"%hp_label".text = "hp:" + str(target.hp) + '/' + str(target.max_hp)
		$"%spd_label".text = 'spd:' + str(target.speed)
		$"%dmg_label".text = 'dmg: ' + str(target.damage)
		$"stats/def_label".text = 'def ' + str(target.defense)
	if target.is_in_group('player'):
		$"%hp_label".text = "hp:" + str(target.stats.hp)
		$"%spd_label".text = 'spd:'+ str(target.stats.speed)
		$"stats/def_label".text = 'def ' + str(target.stats.defense)
		$"%dmg_label".text = 'dmg: ' + str(target.stats.base_damage + target.stats.weapon_damage)
	
func remove(body) -> void:
	if is_instance_valid(body):
		if body == target:
			$"%remove_timer".start(0.5)
			yield($"%remove_timer", "timeout")
			target.has_overhead_stats = false
			queue_free()

func hard_remove(body) -> void:
	if body == target:
		target.has_overhead_stats = false
		queue_free()

func cancel_remove(target) -> void:
	if target == get_parent():
		$"%remove_timer".stop()

func scroll_h_bar(amount:int,target) -> void:
	if scroll_finished == false:
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(target, 'scroll_horizontal', amount, float(amount/50))
		yield(tween,"finished")
		scroll_finished = true
		scroll_timer.start(1.0)
	else:
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(target, 'scroll_horizontal', -amount, float(amount/50))
		yield(tween,"finished")
		scroll_finished = false
		scroll_timer.start(1.0)


func _on_scroll_timer_timeout() -> void:
	scroll_h_bar(8*len(name_label.text), name_scroll_bar)
	
