class_name OverheadLabel

extends Node2D

onready var animation: AnimationPlayer = $"%AnimationPlayer"
onready var label: Label = $"%Label"


func set_text(text:String, color:Color, size:float) -> void:
	animation = $"%AnimationPlayer"
	label = $"%Label"
	label.modulate = color
# warning-ignore:standalone_expression
	self.scale * size
	label.text = text
	animation.queue("FadeAway")
	
func delayed_set_text(text:String, color:Color, size:float, timer) -> void:
	yield(timer,'timeout')
	set_text(text,color,size)

func set_position(target) -> void:
	self.position = target.position + Vector2(rand_range(-10,10),rand_range(-10,10))

func check_if_null() -> bool:
	label = $"%Label"
	if label.text == 'null':
		return true
	else:
		return false
