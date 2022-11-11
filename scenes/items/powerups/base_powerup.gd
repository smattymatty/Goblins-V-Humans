class_name PowerUp
extends Node2D

export var nametag = 'Basic Boost'
export var function = '+ 1 basic stats'
export var description = '+1 to all basic stats'

onready var info: Node2D = $"%info"
onready var name_label: Label = $"%name_label"
onready var desc_label: Label = $"%desc_label"
onready var animation: AnimationPlayer = $"%AnimationPlayer"

func _ready() -> void:
	info.hide()

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group('player') or body.is_in_group('enemy'):
		body.collect_powerup(function)
		SignalManager.emit_console_label(body.nametag + ' has picked up ' + nametag, Color(0.79,0.83,0.53,1))
		self.queue_free()


func _on_target_area_area_entered(area: Area2D) -> void:
	name_label.text = nametag
	desc_label.text = description
	info.show()
	
	animation.queue("Appear")
	

func _on_target_area_area_exited(area: Area2D) -> void:
	animation.queue("Disappear")
	yield(animation,"animation_finished")
	info.hide()
