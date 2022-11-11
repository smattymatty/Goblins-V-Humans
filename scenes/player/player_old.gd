extends Character

export(Resource) var stats = stats as PlayerStats

var speed

func _ready() -> void:
	PREV_STATE = STATES.FREE
	nametag = stats.nametag
	speed = stats.speed
	stats.hp = stats.max_hp
	$"%extra_sprite".hide()

func _turn_start() -> void:
	set_state(STATES.FREE)
	if on_death_fog:
		take_fog_damage()
	
func _turn_end() -> void:
	set_state(STATES.NOT_FREE)
	yield(animation,'animation_finished')
	TurnManager.player_turn_finished()
	
func _process(delta: float) -> void:
	speed = stats.speed # need a local variable to read from Entities script that calculates speeds

func _unhandled_input(event: InputEvent) -> void:
	match STATE:
		STATES.FREE:
			if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down") or event.is_action_pressed("ui_left"):
				move(event)
			if event.is_action_pressed("end_turn"):
				animation.queue('EndTurnEarly')
				_turn_end()

func move(event) -> void:
	if event.is_action_pressed("ui_down"):
		last_moved_direction = 'Down'
		if not raycast_down.is_colliding():
			self.global_position.y += 32
			animation.queue('MoveDown')
			_turn_end()
		else:
			handle_collisions(raycast_down.get_collider())
	elif event.is_action_pressed("ui_up"):
		last_moved_direction = 'Up'
		if not raycast_up.is_colliding():
			self.global_position.y -= 32
			animation.queue('MoveUp')
			_turn_end()
		else:
			handle_collisions(raycast_up.get_collider())
	elif event.is_action_pressed("ui_left"):
		last_moved_direction = 'Left'
		if not raycast_left.is_colliding():
			self.global_position.x -= 32
			animation.queue('MoveLeft')
			_turn_end()
		else:
			handle_collisions(raycast_left.get_collider())
	elif event.is_action_pressed("ui_right"):
		last_moved_direction = 'Right'
		if not raycast_right.is_colliding():
			self.global_position.x += 32
			animation.queue('MoveRight')
			_turn_end()
		else:
			handle_collisions(raycast_right.get_collider())
			
func handle_collisions(collided_with) -> void:
	if collided_with.is_in_group('enemy'):
		attack(collided_with)
	
func attack(target) -> void:
	animation.play('Attack' + str(last_moved_direction))
	var total_damage = stats.base_damage + stats.weapon_damage
	target.take_damage(total_damage, self)
	_turn_end()

func take_damage(amount, damager) -> void:
	stats.hp -= clamp((amount - stats.defense), 1,1000000)
	SignalManager.emit_console_label(str(damager.nametag) + ' dealt ' + str(amount) + " damage to " + str(self.stats.nametag), Color.white)
	if stats.hp <= 0:
		die()
		
func take_fog_damage() -> void:
	var amount = round(((stats.max_hp/10) + fog_multiplier) * fog_multiplier)
	stats.hp -= amount
	animation.queue('FogDamage')
	fog_multiplier += 0.1
	SignalManager.emit_console_label('The Death Fog dealt ' + str(amount) + " damage to " + str(self.stats.nametag), Color.white)
	if stats.hp <= 0:
		die()

func die() -> void:
	queue_free()
	print('you are dead')
	SignalManager.emit_enemy_died(self)
