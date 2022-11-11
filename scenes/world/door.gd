extends StaticBody2D

onready var animation: AnimationPlayer = $AnimationPlayer

var open = false


func _ready() -> void:
# warning-ignore:return_value_discarded
	SignalManager.connect('moved_up',self,'close')
	TurnManager.connect("open_door",self,'open_self')

func open_self() -> void:
	if not open:
		animation.queue('Open')
		open = true

func close() -> void:
	if open:
		animation.queue("RESET")
		open = false


func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group('player'):
		SignalManager.emit_entered_door()
