extends Node2D

var entities_array :  Array
var speeds : Array
var sorted_entities : Array
var speed_sorted_nametags : Array
var death_fogs : Array

func _ready() -> void:
	create_entity_speed_arrays()
	TurnManager.connect("player_turn_finished", self, 'next_turn')
#	TurnManager.connect("enemy_turn_begin", self, 'calculate_speeds')
	TurnManager.connect("enemy_turn_finished", self, 'next_turn')
	TurnManager._round_start()
	SignalManager.connect("enemy_died", self, "remove_from_array")


func create_entity_speed_arrays() -> void:
	entities_array = get_children()
	death_fogs = get_tree().get_nodes_in_group('death fog')
	for i in entities_array.size():
		speeds.append(entities_array[i].speed)
	var amount_of_entities = entities_array.size()
	var top_3_speeds:Array
	var steps = 0
	while sorted_entities.size() < amount_of_entities:
		for i in entities_array: # only put the entity in the array if it's speed is the highest, do this until the sorted array is full
			if i.speed == speeds.max():
				sorted_entities.push_back(i)
				if top_3_speeds.size() < 3:
					top_3_speeds.append(i.speed)
				speeds.erase(speeds.max())
				entities_array.erase(i)
				steps += 1
			else:
				steps += 1
	speed_sorted_nametags = convert_to_nametags(sorted_entities)
	SignalManager.emit_update_time_to_move(sorted_entities)
	for i in death_fogs:
		i._turn_start()
	
	Global.entities = sorted_entities
	Global.top_3_speeds = top_3_speeds
	
	if SignalManager.debug_level > 5:
		print('SPEED SORT: ', speed_sorted_nametags, ' took ', steps, ' steps. Top 3: ', top_3_speeds)
	
	next_turn()
			
func next_turn() -> void:
	yield(get_tree().create_timer(SignalManager.time_between_turns),'timeout')
	SignalManager.emit_speed_array(sorted_entities)
	if sorted_entities.size() > 0:
		sorted_entities[0]._turn_start()
		sorted_entities.pop_front()
	else:
		create_entity_speed_arrays()
		TurnManager.emit_turn_passed()

#	if sorted_entities[0].is_in_group('player'):
#		sorted_entities[0]._turn_start()
	

func remove_from_array(enemy) -> void:
	entities_array.erase(enemy)
	sorted_entities.erase(enemy)
	speed_sorted_nametags.erase(enemy)
	speeds.erase(enemy.speed)
	SignalManager.emit_speed_array(sorted_entities)

func convert_to_nametags(entity_array) -> Array:
	var new_array:Array = []
	for i in entity_array:
		new_array.append(i.nametag)
	return new_array
	
func get_top_3(speed_array):
	print(' GET TOP 3 ! ! ! ')
	var dummy_array = speed_array
	print(dummy_array, ' ! ! ! ')
	var top_3:Array
	return dummy_array
	
