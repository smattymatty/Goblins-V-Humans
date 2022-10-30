class_name Enemy

extends Character

export(Resource) var stats = stats as EnemyStats

var nametag
var hp
var damage
var speed
var is_upgraded = false
var on_enemy_ground = false
var on_center_ground = false


onready var can_move : bool
onready var max_hp = stats.base_hp

func _ready() -> void:
	nametag = stats.nametag
	hp = stats.base_hp
	speed = stats.base_speed
	damage = stats.base_damage
	
func move(direction) -> void:
	print(self, ' moved ', direction)
	if can_move == true:
		if direction == 'Left':
			animation.queue('MoveLeft')
			self.global_position.x -= 32
			yield(animation, "animation_finished")
			TurnManager.enemy_turn_finished()
		if direction == 'Right':
			animation.queue('MoveRight')
			self.global_position.x += 32
			yield(animation, "animation_finished")
			TurnManager.enemy_turn_finished()
		if direction == 'Down':
			self.global_position.y += 32
			animation.queue('MoveDown')
			yield(animation, "animation_finished")
			TurnManager.enemy_turn_finished()
		if direction == 'Up':
			self.global_position.y -= 32
			animation.queue('MoveUp')
			yield(animation, "animation_finished")
			TurnManager.enemy_turn_finished()
	else:
		TurnManager.enemy_turn_finished()
				
func attack(target, direction) -> void:
	print(self, ' attacked ', direction)
	animation.play('Attack' + str(direction))
	var total_damage = damage * stats.damage_multiplier
	target.take_damage(total_damage, self)
	SignalManager.emit_console_label(str(stats.nametag) + ' dealt ' + str(total_damage) + " damage to " + str(target.stats.nametag), Color.white)
	yield(animation, "animation_finished")
	TurnManager.enemy_turn_finished()

func take_damage(amount, damager) -> void:
	if hp > 0:
		hp -= amount
		SignalManager.emit_console_label(str(damager.stats.nametag) + ' dealt ' + str(amount) + " damage to " + str(self.stats.nametag), Color.white)
	elif hp <= 0:
		die()

func die() -> void:
	SignalManager.emit_console_label(str(stats.nametag) + ' has died!', Color.red)
	SignalManager.emit_enemy_died(self)
	queue_free()
	
func upgrade() -> void:
	animation.play('Upgrade')
	is_upgraded = true
	can_move = false
	SignalManager.emit_console_label(nametag + ' has been promoted to ' + ('Veteran ' + nametag), Color.yellow)
	yield(animation, "animation_finished")
	TurnManager.enemy_turn_finished()
