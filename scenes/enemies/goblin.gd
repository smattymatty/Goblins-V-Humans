extends Enemy

func _turn_start() -> void:
	can_move = true
	if on_enemy_ground == true and is_upgraded == false:
		upgrade()
	if can_move == true: #Upgrading and activating skills sets this to false
		check_collisions()

func check_collisions() -> void:
	yield(get_tree().create_timer(0.02), 'timeout')
	if raycast_left.is_colliding():
		if raycast_left.get_collider().is_in_group('player') or raycast_left.get_collider().is_in_group('human'):
			attack(raycast_left.get_collider(), 'Left')
		else:
			move('Right')
	elif raycast_down.is_colliding():
		if raycast_down.get_collider().is_in_group('player') or raycast_down.get_collider().is_in_group('human'):
			attack(raycast_down.get_collider(), 'Down')
	elif raycast_up.is_colliding():
		if raycast_up.get_collider().is_in_group('player') or raycast_up.get_collider().is_in_group('human'):
			attack(raycast_up.get_collider(), 'Up')
	elif raycast_right.is_colliding():
		if raycast_right.get_collider().is_in_group('player') or raycast_right.get_collider().is_in_group('human'):
			attack(raycast_right.get_collider(), 'Right')
	else:
		var direction_to_move = decide_direction_to_move()
		move(direction_to_move)
	
	
func decide_direction_to_move() -> String:
	if is_upgraded == false:
		return "Left"
	if is_upgraded == true:
		return "Right"
	else:
		print('something went wrong with is_upgraded')
		return 'null'


