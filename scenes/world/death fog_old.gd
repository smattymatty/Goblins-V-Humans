extends StaticBody2D

onready var sprite: Sprite = $Sprite
onready var raycast_down: RayCast2D = $"%Raycast down"
onready var raycast_up: RayCast2D = $"%Raycast up"
onready var raycast_right: RayCast2D = $"%Raycast right"
onready var raycast_left: RayCast2D = $"%Raycast left"

onready var animation: AnimationPlayer = $AnimationPlayer

var nametag = 'Death Fog'
var directions = ['Left','Right','Down','Up']
var direction : Vector2
var has_instanced : bool = false


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	randomize()
	TurnManager.connect('turn_passed', self, '_on_turn_passed')

func _on_turn_passed() -> void:
	change_frames()
#	if has_instanced == false:
	check_collisions()
	check_collisions()


func change_frames() -> void:
	if TurnManager.turns_passed % 2 == 0:
		sprite.frame = 128
	else:
		sprite.frame = 129
		
func check_collisions() -> void:
	yield(get_tree().create_timer(0.2), 'timeout')
	var collider
	directions.shuffle()
	for i in directions:
		if i == 'Left':
			collider = raycast_left.get_collider()
			if collider == null:
				instance_self(Vector2(-32,0))
				directions.erase('Left')
				break
		elif i == 'Right':
			collider = raycast_right.get_collider()
			if collider == null:
				instance_self(Vector2(32,0))
				directions.erase('Right')
				break
		elif i == 'Down':
			collider = raycast_down.get_collider()
			if collider == null:
				instance_self(Vector2(0,32))
				directions.erase('Down')
				break
		elif i == 'Up':
			collider = raycast_up.get_collider()
			if collider == null:
				instance_self(Vector2(0,-32))
				directions.erase('Up')
				break
		
		if collider != null:
			if collider.is_in_group('enemy') or collider.is_in_group('player'):
				attack(collider, i)
			else: 
				pass
				
				
func instance_self(direction:Vector2) -> void:
	var effects_node = self.get_parent()
	var death_fog = load("res://scenes/world/death fog_old.tscn")
	var death_fog_instance = death_fog.instance()
	death_fog_instance.global_position = self.global_position + direction
	effects_node.add_child(death_fog_instance)
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

			
