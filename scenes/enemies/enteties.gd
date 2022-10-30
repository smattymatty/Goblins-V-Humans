extends YSort

var entities_array :  Array
var speeds : Array
var sorted_entities : Array

func _ready() -> void:
	create_entity_speed_arrays()
	TurnManager.connect("player_turn_finished", self, 'next_turn')
#	TurnManager.connect("enemy_turn_begin", self, 'calculate_speeds')
	TurnManager.connect("enemy_turn_finished", self, 'next_turn')
	SignalManager.connect("enemy_died", self, "remove_from_array")

func create_entity_speed_arrays() -> void:
	entities_array = get_children()
	
	for i in entities_array.size():
		speeds.append(entities_array[i].speed)
	var amount_of_entities = entities_array.size()
	var steps = 0
	while sorted_entities.size() < amount_of_entities:
		for i in entities_array: # only put the entity in the array if it's speed is the highest, do this until the sorted array is full
			if i.speed == speeds.max():
				sorted_entities.push_back(i)
				speeds.erase(speeds.max())
				entities_array.erase(i)
				steps += 1
			else:
				steps += 1
#	print(steps, ' sorted: ', sorted_entities)
	next_turn()
			
func next_turn() -> void:
	if sorted_entities.size() > 0:
		sorted_entities[0]._turn_start()
		sorted_entities.pop_front()
#		print('next turn, entities left to play: ', sorted_entities)
	else:
		create_entity_speed_arrays()
	SignalManager.emit_speed_array_info(sorted_entities)

func remove_from_array(enemy) -> void:
	entities_array.erase(enemy)
	sorted_entities.erase(enemy)
	speeds.erase(enemy.speed)
