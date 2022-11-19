extends CanvasLayer

onready var overhead_stats_node: Control = $"%overhead stats"

func _ready() -> void:
	SignalManager.connect("overhead_stats",self,'spawn_overhead_stats')
	
func spawn_overhead_stats(target, instance) -> void:
#	var existing_instances = overhead_stats_node.get_children()
#	for i in existing_instances:
#		if existing_instances.size() == 1:
#			break
#		i.queue_free()
#		existing_instances = overhead_stats_node.get_children()
	instance.rect_position = target.overhead.global_position
	instance.stored_target = target
	overhead_stats_node.add_child(instance)
