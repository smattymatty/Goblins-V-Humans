extends YSort

var entities_array :  Array
var speeds : Array
var sorted_entities : Array
var speed_sorted_nametags : Array

func _ready() -> void:
	create_entity_speed_arrays()
	TurnManager.connect("player_turn_finished", self, 'next_turn')
#	TurnManager.connect("enemy_turn_begin", self, 'calculate_speeds')
	TurnManager.connect("enemy_turn_finished", self, 'next_turn')
	TurnManager._round_start()
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
	speed_sorted_nametags = convert_to_nametags(sorted_entities)
	print('SPEED SORT: ', speed_sorted_nametags, ' took ', steps, ' steps')
	next_turn()
			
func next_turn() -> void:
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
	print(enemy, ' removed from sorted speeds array')
	entities_array.erase(enemy)
	sorted_entities.erase(enemy)
	speed_sorted_nametags.erase(enemy)
	speeds.erase(enemy.speed)

func convert_to_nametags(entity_array) -> Array:
	var new_array:Array = []
	for i in entity_array:
		new_array.append(i.nametag)
	return new_array
