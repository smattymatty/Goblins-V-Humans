class_name EffectBlock
extends Control


var label
onready var color_rect: ColorRect = $"%ColorRect"
onready var color_rect_2: ColorRect = $"%ColorRect2"
onready var desc_label: Label = $"%desc_label"

func _enter_tree() -> void:
	label = $"%Label"

func _ready() -> void:
	desc_label.hide()

func _process(delta: float) -> void:
	if is_instance_valid(self):
		color_rect.rect_size.x = label.rect_size.x + 4
		color_rect_2.rect_size.x = label.rect_size.x + 2
		self.rect_min_size.x = color_rect.rect_size.x

func set_label_text(text, color:Color):
	$"%Label".text = str(text)
	self.modulate = color

func set_description(text):
	desc_label.text = str(text)

func _on_Label_mouse_entered() -> void:
	desc_label.show()
