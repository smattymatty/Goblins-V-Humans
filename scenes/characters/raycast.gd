extends RayCast2D


export(String, 'Up', 'Down', 'Left', 'Right') var direction

onready var grandparent = self.get_parent().get_parent()

func _ready() -> void:
	self.add_exception(grandparent)
		
