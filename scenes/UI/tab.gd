extends Control

signal button_pressed

var selected:bool = false

onready var color_rect: ColorRect = $ColorRect
onready var color_rect_2: ColorRect = $ColorRect2
onready var label: Label = $Label
onready var texture_button: TextureButton = $TextureButton

func invert_colors() -> void:
	color_rect.color = Color.black
	color_rect_2.color = Color.white
	label.modulate = Color.black
	selected = true
	
func revert_colors() -> void:
	color_rect.color = Color.white
	color_rect_2.color = Color.black
	label.modulate = Color.white
	selected = false


func _on_TextureButton_mouse_entered() -> void:
	if selected == false:
		label.modulate = Color.yellow


func _on_TextureButton_mouse_exited() -> void:
	if selected == false:
		label.modulate = Color.white


func _on_TextureButton_pressed() -> void:
	emit_signal('button_pressed')
