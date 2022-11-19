extends Control

onready var options: Control = $"%options"
onready var remove_options_timer: Timer = $"%remove_options_timer"

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_topleftbutton_pressed() -> void:
	if options.visible == true:
		options.hide()
	else:
		options.show()


func _on_options_mouse_exited() -> void:
	print('mouse exit')
	remove_options_timer.start()

func _on_options_mouse_entered() -> void:
	print('mouse enter')
	remove_options_timer.stop()

func _on_remove_options_timer_timeout() -> void:
	options.hide()
	
func _on_topleftbutton_mouse_entered() -> void:
	remove_options_timer.stop()
	$toprightbutton/ColorRect2.color = Global.YELLOW


func _on_topleftbutton_mouse_exited() -> void:
	remove_options_timer.start()
	$toprightbutton/ColorRect2.color = Color.black
