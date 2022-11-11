extends Character


onready var effects = get_parent()
onready var sprite: Sprite = $Sprite

var speed:int
var directions = ['Left','Right','Down','Up']
var direction : Vector2
var has_instanced : bool = false
var stuck:bool = false

func _enter_tree() -> void:
	nametag = 'death_fog'
	speed = 1000
	randomize()
#	TurnManager.connect('turn_passed', self, '_turn_start')


func _turn_start() -> void:
	directions = ['Left','Right','Down','Up']
	change_frames()
#	if has_instanced == false:
	if directions.size() > 0:
		check_collisions()
	else:
		pass


func change_frames() -> void:
	if sprite.frame == 129:
		sprite.frame = 128
	else:
		sprite.frame = 129
		
func check_collisions() -> void:
	yield(get_tree().create_timer(0.2), 'timeout')
	var collider
	directions.shuffle()
	for i in directions:
		match i:
			'Left': 
				if raycast_left.is_colliding():
					collider = raycast_left.get_collider()
					if collider.is_in_group('tile') or collider.is_in_group('death fog'):
						directions.erase(i)
				else:
					instance_self(Vector2(-32,0))
			'Right':
				if raycast_right.is_colliding():
					collider = raycast_right.get_collider()
					if collider.is_in_group('tile') or collider.is_in_group('death fog'):
						directions.erase(i)
				else:
					instance_self(Vector2(32,0))
			'Up':
				if raycast_up.is_colliding():
					collider = raycast_up.get_collider()
					if collider.is_in_group('tile') or collider.is_in_group('death fog'):
						directions.erase(i)
				else:
					instance_self(Vector2(0,-32))
			'Down':
				if raycast_down.is_colliding():
					collider = raycast_down.get_collider()
					if collider.is_in_group('tile') or collider.is_in_group('death fog'):
						directions.erase(i)
				else:
					instance_self(Vector2(0,32))
				
				
				
#		if collider != null:
#			pass
#		else: 
#			stuck = true
				
				
func instance_self(direction:Vector2) -> void:
	var effects_node = self.get_parent()
	var death_fog = load("res://scenes/world/death_fog.tscn")
	var death_fog_instance = death_fog.instance()
	death_fog_instance.global_position = self.global_position + direction
	effects_node.add_child(death_fog_instance)
	end_turn()
#	has_instanced = true
	
func attack(target, direction) -> void:
	animation.queue('Attack'+direction)
	print('death fog should attack ', target, direction)
	if target.is_in_group('enemy') and target.hp > -1:
		target.take_true_damage(round(target.max_hp / 10 * target.fog_multiplier), self)
		target.fog_multiplier += 0.5
	if target.is_in_group('player') and target.stats.hp > -1:
		target.take_true_damage(round(target.stats.max_hp / 10 * target.fog_multiplier), self)
		target.fog_multiplier += 0.5
	yield(animation,"animation_finished")

func end_turn() -> void:
	TurnManager.emit_death_fog_finished(self)


func _on_collision_area_body_entered(body: Node) -> void:
	var groups = body.get_groups()
	if groups.has('enemy') or groups.has('player'):
		body.on_death_fog = true


func _on_collision_area_body_exited(body: Node) -> void:
	var groups = body.get_groups()
	if groups.has('enemy') or groups.has('player'):
		body.on_death_fog = false
