extends Character

export(Resource) var stats = stats as PlayerStats

var speed

func _ready() -> void:
	speed = stats.speed
	stats.hp = stats.max_hp
# warning-ignore:return_value_discarded
	TurnManager.connect("player_turn_finished", self, "end_of_turn")

func _turn_start() -> void:
	print(self, ' turn start')
	turn_to_move = true
	
func _process(delta: float) -> void:
	speed = stats.speed # need a local variable to read from Entities script that calculates speeds

func _unhandled_input(event: InputEvent) -> void:
	if turn_to_move == true:
		move(event)
		if event.is_action_pressed("end_turn"):
			end_turn_early()

func move(event) -> void:
	if event.is_action_pressed("ui_down"):
		last_moved_direction = 'Down'
		if not raycast_down.is_colliding():
			self.global_position.y += 32
			animation.play('MoveDown')
			TurnManager.player_turn_finished()
		else:
			handle_collisions(raycast_down.get_collider())
	elif event.is_action_pressed("ui_up"):
		last_moved_direction = 'Up'
		if not raycast_up.is_colliding():
			self.global_position.y -= 32
			animation.play('MoveUp')
			TurnManager.player_turn_finished()
		else:
			handle_collisions(raycast_up.get_collider())
	elif event.is_action_pressed("ui_left"):
		last_moved_direction = 'Left'
		if not raycast_left.is_colliding():
			self.global_position.x -= 32
			animation.play('MoveLeft')
			TurnManager.player_turn_finished()
		else:
			handle_collisions(raycast_left.get_collider())
	elif event.is_action_pressed("ui_right"):
		last_moved_direction = 'Right'
		if not raycast_right.is_colliding():
			self.global_position.x += 32
			animation.play('MoveRight')
			TurnManager.player_turn_finished()
		else:
			handle_collisions(raycast_right.get_collider())
			
func end_of_turn() -> void:
	turn_to_move = false

func handle_collisions(collided_with) -> void:
	if collided_with.is_in_group('enemy'):
		attack(collided_with)
	
		
func attack(target) -> void:
	animation.play('Attack' + str(last_moved_direction))
	var total_damage = stats.base_damage + stats.weapon_damage
	target.take_damage(total_damage, self)
	TurnManager.player_turn_finished()

func take_damage(amount, damager) -> void:
	stats.hp -= amount
	if stats.hp <= 0:
		die()

func die() -> void:
	queue_free()
	print('you are dead')
	SignalManager.emit_enemy_died(self)
	
func end_turn_early() -> void:
	yield(get_tree().create_timer(0.2), 'timeout')
	TurnManager.player_turn_finished()
