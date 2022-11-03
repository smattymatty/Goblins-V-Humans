extends StaticBody2D

onready var animation: AnimationPlayer = $AnimationPlayer

var open = false


func _ready() -> void:
	TurnManager.connect("open_door",self,'open')

func open() -> void:
	if not open:
		animation.queue('Open')
		open = true
