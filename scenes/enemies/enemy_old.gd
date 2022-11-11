class_name EnemyOld

extends Character

export(Resource) var stats = stats as EnemyStats
#export(Resource) var info = info as PersonalInfo

var info = load("res://resources/enemies/personal_info.tres")
var hp
var max_hp
var damage
var speed
var defense
var is_upgraded = false
var times_attacked: int = 0
var attacks_per_turn:int = 1
var on_ground:String = 'Ally'
var collider = null
var collider_direction:String = 'null'
var preferred_directions:Array = [] # set this in the individual enemy scripts
var directions_checked:Array = [] # check_for_movement function will fill this, should clear on _turn_end
var times_moved:int = 0

onready var can_move : bool
onready var raycast_timer: Timer = $check_for_movement_timer

func _ready() -> void:
	TurnManager.connect('turn_passed',self,'_whole_turn_passed')
	SignalManager.connect("enemy_died",self,'check_collider_death')
	STATE = STATES.FREE
	set_state(STATES.FREE)
	max_hp = stats.base_hp + round(rand_range(-20,20))
	hp = max_hp
	speed = stats.base_speed + round(rand_range(-5,5))
	damage = stats.base_damage + round(rand_range(-5,5))
	defense = stats.base_defense + round(rand_range(-5,5))
	
func _whole_turn_passed() -> void:
	times_moved = 0

func _turn_start() -> void: # each individual enemy overrides this
	pass 

func _turn_end() -> void:
	directions_checked.clear()
	if STATE == STATES.FREE:
		set_state(STATES.NOT_FREE)
	TurnManager.enemy_turn_finished()

	
func move(direction,end_turn:bool) -> void:
	if direction == 'Left':
		animation.queue('MoveLeft')
		self.global_position.x -= 32
		last_moved_direction = 'Left'
		yield(animation, "animation_finished")
	if direction == 'Right':
		animation.queue('MoveRight')
		self.global_position.x += 32
		yield(animation, "animation_finished")
	if direction == 'Down':
		self.global_position.y += 32
		animation.queue('MoveDown')
		yield(animation, "animation_finished")
	if direction == 'Up':
		self.global_position.y -= 32
		animation.queue('MoveUp')
		yield(animation, "animation_finished")
	if end_turn == true:
		_turn_end()

func move_two_tiles(direction) -> void:
	if direction == 'Left':
		animation.queue('MoveLeftTwoTiles')
		self.global_position.x -= 64
		last_moved_direction = 'Left'
		yield(animation, "animation_finished")
	if direction == 'Right':
		animation.queue('MoveRightTwoTiles')
		self.global_position.x += 64
		yield(animation, "animation_finished")
	if direction == 'Down':
		self.global_position.y += 64
		animation.queue('MoveDownTwoTiles')
		yield(animation, "animation_finished")
	if direction == 'Up':
		self.global_position.y -= 64
		animation.queue('MoveUpTwoTiles')
		yield(animation, "animation_finished")
	_turn_end()
		
#func check_upgrade_moves(amount,direction) -> void:
#		if is_upgraded == true and times_moved < amount:
#			times_moved += 1
#			_turn_start()
#			preferred_directions = [direction]
#		else:
#			_turn_end()
			
		
		
func cant_move() -> void:
	# should be called when check_for_movement function can't find a place to move after 4 iterations
	animation.queue('CantMove')
	print(self.nametag, 'cannot move')
	yield(animation,"animation_finished")
	_turn_end()

func attack(target, direction) -> void:
	set_state(STATES.IN_COMBAT)
	times_attacked += 1
	if SignalManager.debug_level > 3:
		print('ATTACK: ', self.nametag, " targeted ", target.nametag, ' in direction - ', direction, ' times attacked: ', times_attacked)
	animation.play('Attack' + str(direction))
	var total_damage = damage * stats.damage_multiplier
	target.take_damage(total_damage, self)
#	if target.is_in_group('player'):
#		if target.stats.hp <= 0:
#			set_state(STATES.FREE)
#			collider = null
#	elif target.is_in_group('enemy'):
#		if target.hp <= 0:
#			set_state(STATES.FREE)
#			collider = null
	yield(animation, "animation_finished")
	_turn_end()

func take_damage(amount, damager) -> void:
	if hp > 0:
		hp -= clamp((amount - defense), 1,1000000)
		SignalManager.emit_console_label(str(damager.nametag) + ' dealt ' + str(amount) + " damage to " + str(self.nametag), Color.white)
		set_state(STATES.IN_COMBAT)
	else:
		die()

func take_fog_damage() -> void:
	var amount = round(((max_hp/10) + fog_multiplier) * fog_multiplier)
	hp -= amount
	animation.queue('FogDamage')
	fog_multiplier += 0.1
	SignalManager.emit_console_label('The Death Fog dealt ' + str(amount) + " damage to " + str(self.nametag), Color.white)
	if hp <= 0:
		die()

func die() -> void:
	SignalManager.emit_enemy_died(self)
	queue_free()
	
func upgrade() -> void:
	animation.queue('Upgrade')
	is_upgraded = true
	can_move = false
	SignalManager.emit_console_label(nametag + ' has been promoted to ' + ('Veteran ' + nametag), Color.yellow)
	double_raycast_sizes()
	yield(animation, "animation_finished")
	TurnManager.enemy_turn_finished()

func double_raycast_sizes() -> void:
	raycast_down.cast_to.y *= 2
	raycast_left.cast_to.x *= 2
	raycast_up.cast_to.y *= 2
	raycast_right.cast_to.x *= 2

#func run_away(target, direction) -> void:
#	move_randomly(get_available_spots_to_move(direction))
#	print(self.nametag + ' is running away from ' + str(target))

func check_for_enemies(directions:Array, shuffled:bool) -> void:
	var steps:int = 0
	for i in directions:
		match i:
			'Left':
				steps+=1
				if raycast_left.is_colliding():
					steps+=1
					collider = raycast_left.get_collider()
					if collider.is_in_group('player') or collider.is_in_group('enemy'):
						steps+=1
						if check_if_ally(collider) == false:
							steps+=1
							if is_upgraded == false:
								attack(collider, i)
							elif is_upgraded == true and self.position.distance_to(collider.position) == 32:
								attack(collider,i)
							elif is_upgraded == true and self.position.distance_to(collider.position) == 64:
								STATE = STATES.IN_COMBAT
								move(i, false)
								yield(animation,"animation_finished")
								attack(collider, i)
							break
						elif check_if_ally(collider) == true:
							steps+=1
							collider = null
							break
				else:
					set_state(STATES.FREE)
			'Right':
				steps+=1
				if raycast_right.is_colliding():
					steps+=1
					collider = raycast_right.get_collider()
					if collider.is_in_group('player') or collider.is_in_group('enemy'):
						steps+=1
						if check_if_ally(collider) == false:
							steps+=1
							if is_upgraded == false:
								attack(collider, i)
							elif is_upgraded == true and self.position.distance_to(collider.position) == 32:
								attack(collider,i)
							elif is_upgraded == true and self.position.distance_to(collider.position) == 64:
								STATE = STATES.IN_COMBAT
								move(i, false)
								yield(animation,"animation_finished")
								attack(collider, i)
							break
						elif check_if_ally(collider) == true:
							steps+=1
							collider = null
							break
				else:
					set_state(STATES.FREE)
			'Down':
				steps+=1
				if raycast_down.is_colliding():
					steps+=1
					collider = raycast_down.get_collider()
					if collider.is_in_group('player') or collider.is_in_group('enemy'):
						steps+=1
						if check_if_ally(collider) == false:
							steps+=1
							if is_upgraded == false:
								attack(collider, i)
							elif is_upgraded == true and self.position.distance_to(collider.position) == 32:
								attack(collider,i)
							elif is_upgraded == true and self.position.distance_to(collider.position) == 64:
								STATE = STATES.IN_COMBAT

								move(i, false)
								yield(animation,"animation_finished")
								attack(collider, i)
							break
						elif check_if_ally(collider) == true:
							steps+=1
							collider = null
							break
				else:
					set_state(STATES.FREE)
			'Up':
				steps+=1
				if raycast_up.is_colliding():
					steps+=1
					collider = raycast_up.get_collider()
					if collider.is_in_group('player') or collider.is_in_group('enemy'):
						steps+=1
						if check_if_ally(collider) == false:
							steps+=1
							if is_upgraded == false:
								attack(collider, i)
							elif is_upgraded == true and self.position.distance_to(collider.position) == 32:
								attack(collider,i)
							elif is_upgraded == true and self.position.distance_to(collider.position) == 64:
								STATE = STATES.IN_COMBAT
								move(i, false)
								yield(animation,"animation_finished")
								attack(collider, i)
							break
						elif check_if_ally(collider) == true:
							steps+=1
							collider = null
							break
				else:
					set_state(STATES.FREE)
	if collider == null:
		set_state(STATES.FREE)
	elif collider != null and collider.is_in_group('tile'): # crashes on freed enemy
		set_state(STATES.FREE)
	if SignalManager.debug_level > 3:	
		print('ENEMY CHECK: ', self.nametag, ' has found ', collider, ' took ', steps, ' steps.')

func check_for_movement(directions:Array, shuffled:bool, iteration:int) -> void:
	# First must check the raycast before it moves. It will try the first directory in the array
	# or restarts if colliding with a wall. If no collisions
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
					if is_upgraded == false:
						move(i,true)
					elif is_upgraded == true:
						move_two_tiles(i)
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
					if is_upgraded == false:
						move(i,true)
					elif is_upgraded == true:
						move_two_tiles(i)
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
					if is_upgraded == false:
						move(i,true)
					elif is_upgraded == true:
						move_two_tiles(i)
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
					if is_upgraded == false:
						move(i,true)
					elif is_upgraded == true:
						move_two_tiles(i)
				break
	if SignalManager.debug_level > 5:
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
	print("this shouldn't happen -- issue with check_if_ally")
	return false
				
	
func move_randomly(directions:Array) -> void:
	if directions.size() > 0:
		randomize()
		directions.shuffle()
		move(directions[0],true)
		directions.clear()
	else:
		TurnManager.enemy_turn_finished()
		
func check_collider_death(target) -> void:
	# This is called when an enemy dies to make sure they don't stay as collider
	if collider == target:
		collider = null

