class_name Enemy

extends Character

export(Resource) var stats = stats as EnemyStats
#export(Resource) var info = info as PersonalInfo

var info = load("res://resources/enemies/personal_info.tres")
var hp
var damage
var speed
var is_upgraded = false
var on_ground:String = 'Ally'
var collider = null
var collider_direction:String = 'null'
var preferred_directions:Array = [] # set this in the individual enemy scripts
var directions_checked:Array = [] # check_for_movement function will fill this, should clear on _turn_end

onready var can_move : bool
onready var max_hp = stats.base_hp
onready var raycast_timer: Timer = $check_for_movement_timer

func _ready() -> void:
	set_state(STATES.FREE)
	hp = stats.base_hp
	speed = stats.base_speed + round(rand_range(-5,5))
	damage = stats.base_damage

func _turn_end() -> void:
	directions_checked.clear()
	TurnManager.enemy_turn_finished()

	
func move(direction) -> void:
	if direction == 'Left':
		animation.queue('MoveLeft')
		self.global_position.x -= 32
		yield(animation, "animation_finished")
		_turn_end()
	if direction == 'Right':
		animation.queue('MoveRight')
		self.global_position.x += 32
		yield(animation, "animation_finished")
		_turn_end()
	if direction == 'Down':
		self.global_position.y += 32
		animation.queue('MoveDown')
		yield(animation, "animation_finished")
		_turn_end()
	if direction == 'Up':
		self.global_position.y -= 32
		animation.queue('MoveUp')
		yield(animation, "animation_finished")
		_turn_end()
		
func cant_move() -> void:
	# should be called when check_for_movement function can't find a place to move after 10 iterations
	print(self.nametag, 'cannot move')
	_turn_end()

func attack(target, direction) -> void:
	set_state(STATES.IN_COMBAT)
	animation.play('Attack' + str(direction))
	var total_damage = damage * stats.damage_multiplier
	target.take_damage(total_damage, self)
	yield(animation, "animation_finished")
	_turn_end()

func take_damage(amount, damager) -> void:
	if hp > 0:
		hp -= amount
		SignalManager.emit_console_label(str(damager.nametag) + ' dealt ' + str(amount) + " damage to " + str(self.nametag), Color.white)
	else:
		die()

func take_true_damage(amount, damager) -> void:
	if hp > 0:
		hp -= amount
		SignalManager.emit_console_label(str(damager.nametag) + ' dealt ' + str(amount) + " damage to " + str(self.nametag), Color.white)
	else:
		die()

func die() -> void:
	SignalManager.emit_enemy_died(self)
	queue_free()
	
func upgrade() -> void:
	animation.queue('Upgrade')
	is_upgraded = true
	can_move = false
	SignalManager.emit_console_label(nametag + ' has been promoted to ' + ('Veteran ' + nametag), Color.yellow)
	yield(animation, "animation_finished")
	TurnManager.enemy_turn_finished()

#func run_away(target, direction) -> void:
#	move_randomly(get_available_spots_to_move(direction))
#	print(self.nametag + ' is running away from ' + str(target))

func check_for_enemies(directions:Array, shuffled:bool) -> void:
	for i in directions:
		match i:
			'Left':
				if raycast_left.is_colliding():
					collider = raycast_left.get_collider()
					if check_if_ally(collider) == false:
						attack(collider, i)
					else:
						collider = null
						set_state(STATES.FREE)
			'Right':
				if raycast_right.is_colliding():
					collider = raycast_right.get_collider()
					if check_if_ally(collider) == false:
						attack(collider, i)
					else:
						collider = null
						set_state(STATES.FREE)
			'Down':
				if raycast_down.is_colliding():
					collider = raycast_down.get_collider()
					if check_if_ally(collider) == false:
						attack(collider, i)
					else:
						collider = null
						set_state(STATES.FREE)
			'Up':
				if raycast_up.is_colliding():
					collider = raycast_up.get_collider()
					if check_if_ally(collider) == false:
						attack(collider, i)
					else:
						collider = null
						set_state(STATES.FREE)

func check_for_movement(directions:Array, shuffled:bool, iteration:int) -> void:
	# First must check the raycast before it moves. It will try the first directory in the array,
	# then attacks if collided with an enemy, or restarts if colliding with a wall. If no collisions
	# are found, the enemy should move in said direction. directions_checked gets added to on restart.
	var steps = 0
	var times_checked = iteration
	raycast_timer.start(0.02)
	yield(raycast_timer,'timeout')
	
	for i in directions_checked:
		steps += 1
		directions.erase(i)
	
	if shuffled == true:
		randomize()
		directions.shuffle()
	
	if times_checked >= 4:
		cant_move()
	
	for i in directions:
		steps += 1
		match i:
			'Left':
				steps += 1
				if raycast_left.is_colliding():
					steps += 1
					collider = raycast_left.get_collider()
					collider_direction = i
					if collider.is_in_group('tile') or collider.is_in_group('death fog'):
						steps += 1
						directions_checked.append(i)
						check_for_movement(['Right','Down','Up'],true,times_checked+1)
						break
					elif check_if_ally(collider) == true:
						steps += 1
						directions_checked.append(i)
						check_for_movement(['Left','Down','Up'],true,times_checked+1)
						break
				else:
					move('Left')
				break
			'Right':
				steps += 1
				if raycast_right.is_colliding():
					steps += 1
					collider = raycast_right.get_collider()
					collider_direction = i
					if collider.is_in_group('tile') or collider.is_in_group('death fog'):
						steps += 1
						directions_checked.append(i)
						check_for_movement(['Left','Down','Up'],true,times_checked+1)
						break
					elif check_if_ally(collider) == true:
						steps += 1
						directions_checked.append(i)
						check_for_movement(['Left','Down','Up'],true,times_checked+1)
						break
				else:
					move('Right')
				break
			'Down':
				steps += 1
				if raycast_down.is_colliding():
					steps += 1
					collider = raycast_down.get_collider()
					collider_direction = i
					if collider.is_in_group('tile') or collider.is_in_group('death fog'):
						steps += 1
						directions_checked.append(i)
						check_for_movement(['Left','Right','Up'],true,times_checked+1)
						break
					elif check_if_ally(collider) == true:
						steps += 1
						directions_checked.append(i)
						check_for_movement(['Left','Right','Up'],true,times_checked+1)
						break
				else:
					move('Down')
				break
			'Up':
				steps += 1
				if raycast_up.is_colliding():
					steps += 1
					collider = raycast_up.get_collider()
					collider_direction = i
					if collider.is_in_group('tile') or collider.is_in_group('death fog'):
						steps += 1
						directions_checked.append(i)
						check_for_movement(['Left','Right','Down'],true,times_checked+1)
						break
					elif check_if_ally(collider) == true:
						steps += 1
						directions_checked.append(i)
						check_for_movement(['Left','Right','Down'],true,times_checked+1)
						break
				else:
					move('Up')
				break
	print('COLLISION CHECK ', times_checked, ': ', self.nametag, ' collided with ', collider, ' in direction ', collider_direction, ' took ', steps, ' ', directions_checked)
		
			
		
func check_if_ally(target) -> bool:
	var groups_array = self.get_groups()
	groups_array.erase('enemy')
	var group = groups_array[0]
	match group:
		'goblin':
			if target.is_in_group('goblin'):
				return true
			else:
				return false
		'human':
			if target.is_in_group('human'):
				return true
			else: 
				return false
	print("this shouldn't happen")
	return true
				
	
func move_randomly(directions:Array) -> void:
	if directions.size() > 0:
		randomize()
		directions.shuffle()
		move(directions[0])
		directions.clear()
	else:
		TurnManager.enemy_turn_finished()
		

