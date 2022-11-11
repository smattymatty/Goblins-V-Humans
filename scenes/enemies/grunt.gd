extends Enemy

var preferred_directions:Array
var checked_directions:Array
var tiles_moved:int = 1

func _enter_tree() -> void:
	moves_per_turn = 1
	set_state('Combat','Out of Combat')
	set_preferred_directions()
	if self.is_in_group('goblin'):
		$"%Sprite".frame = 1
	elif self.is_in_group('human'):
		$"%Sprite".frame = 3

func _turn_start() -> void:
	set_preferred_directions()
	turn_state = 'Active'
	match combat_state:
		'Out of Combat':
			remaining_moves = moves_per_turn
		'In Combat':
			remaining_moves = 1
	match turn_state:
		"Active":
			check_to_move(preferred_directions)
			
func _turn_end():
	yield(get_tree().create_timer(SignalManager.time_between_turns),"timeout")
	TurnManager.enemy_turn_finished()

func check_to_move(directions:Array) -> void:
	
		match directions[0]:
			'Left':
				check_collisions(directions[0],0)
			'Right':
				check_collisions(directions[0],0)
			'Up':
				check_collisions(directions[0],0)
			'Down':
				check_collisions(directions[0],0)

func check_collisions(direction, iteration):
	if checked_directions.size() < 3:
		iteration += 1
		collider = null
		checked_directions.append(direction)
		for i in checked_directions:
			preferred_directions.erase(i)
		set_raycast_to(direction)
		yield(get_tree(),"idle_frame")
		check_and_set_collider()
		if collider == null or collider.is_in_group('powerup'):
			move(direction, tiles_moved)
		elif collider.is_in_group('tile'):
			check_collisions(preferred_directions[0], iteration+1)
		elif check_if_ally(collider) == false:
			attack(direction,collider)
		elif check_if_ally(collider) == true:
			check_collisions(preferred_directions[0], iteration+1)
	else:
		cant_move()
	if SignalManager.debug_level > 6:
		print('---collision_check--- ', iteration, ' ', self.nametag + ' tried to move in direction: ', direction, 
		' collided with: ', collider, ' checked directions: ', checked_directions)
	
	
func set_preferred_directions() -> void:
	checked_directions = []
	if self.is_in_group('goblin'):
		preferred_directions = ['Left','Up','Down','Right']
	elif self.is_in_group('human'):
		preferred_directions = ['Right', 'Up', 'Down', 'Left']
