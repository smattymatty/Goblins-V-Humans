class_name Enemy


extends Character

var type:String
var tiles_moved:int = 1
var enemy_found = false
var upgraded = false

export(Resource) var stats = stats as EnemyStats
export(Resource) var info


func _ready() -> void:
	SignalManager.connect("update_time_to_move",self,"update_time_to_move")
	raycasts.shuffle()
	
	max_hp = round(stats.base_hp * rand_range(0.8,1.2))
	hp = max_hp
	speed = round(stats.base_speed * rand_range(0.8,1.2))
	damage = round(stats.base_damage * rand_range(0.8,1.2))
	defense = round(stats.base_defense * rand_range(0.8,1.2))
	defense_pierce = round(stats.base_pierce * rand_range(0.8,1.2))
	damage_type = stats.damage_type
	physical_resist = stats.physical_resist
	fire_resist = stats.fire_resist
	ice_resist = stats.ice_resist
	lightning_resist = stats.lightning_resist
	physical_damage = stats.physical_damage
	fire_damage = stats.fire_damage
	ice_damage = stats.ice_damage
	lightning_damage = stats.lightning_damage
	weapon_damage_multi = stats.weapon_damage_multi
	boost_multi = stats.boost_multi
	debuff_multi = stats.debuff_multi
	skill_damage = stats.skill_damage

	
	if self.is_in_group('human'):
		nametag = str(shuffle_grab(Global.human_names)) + " the Human " + stats.nametag
	elif self.is_in_group('goblin'):
		nametag = str(shuffle_grab(Global.goblin_names)) + " the Goblin " + stats.nametag

func _turn_start() -> void: # Should be overridden by further object
	pass

func _process(_delta: float) -> void:
	if hp > max_hp:
		hp = max_hp

func check_for_enemies():
	for i in raycasts:
		check_and_set_collider(i)
		if collider != null:
			if check_if_ally(collider) == true:
				continue
			elif collider.is_in_group('player') or collider.is_in_group('enemy'):
				if int(self.global_position.distance_to(collider.global_position)) == 32:
					set_state('Combat','In Combat')
					debug_label.text = str(self.position.distance_to(collider.position))
					attack(i.direction, collider)
					return true
				else:
					debug_label.text = str(self.position.distance_to(collider.position))
					move(i.direction, tiles_altered(collider))
					attack(i.direction, collider)
					return true
		else:
			continue
			
#	if SignalManager.debug_level > 4:
#		print('---Enemy Check--- ', self.nametag, ' found ', collider, ' direction: ')
		
	if collider == null or collider.is_in_group('powerup') == true or check_if_ally(collider) == true:
		set_state('Combat', 'Out of Combat')
		return false
		
func check_for_powerups():
	for i in raycasts:
		check_and_set_collider(i)
		if collider != null:
			var distance = (self.global_position.distance_to(collider.global_position))
			set_debug_label(distance)
			if collider.is_in_group('powerup'):
				print('P O W E R  U P  D I S T A N C E - - - - - ', distance, ' - - - - - ')
				if distance == 32:
					move(i.direction, 1)
					return true
				else:
					move(i.direction, distance/32)
					return true
		else:
			continue
	if collider == null or collider.is_in_group('powerup') == false:
		return false
			
func tiles_altered(target) -> int:
	if tiles_moved == 1:
		return 1
	elif tiles_moved > 1:
		return tiles_moved - 1
	else:
		print("This shouldn't happen ", 'tiles_altered')
		return 0

func check_if_ally(target) -> bool:
	var target_groups = target.get_groups()
	if self.is_in_group('goblin'):
		if target_groups.has('human') or target_groups.has('player'):
			return false
		else:
			return true
	elif self.is_in_group('human'):
		if target_groups.has('goblin') or target_groups.has('player'):
			return false
		else:
			return true
	return true
	
func update_time_to_move(speeds_array) -> void:
	#Enemies will move faster the more entities are on the screen at a time
	if speeds_array.size() > 0:
		var new_time:float = 2/(float(speeds_array.size()))
		time_to_move = clamp(new_time, 0.02,0.2)
	SignalManager.emit_turn_time_for_ui(time_to_move,speeds_array.size())
		
func upgrade(frame) -> void:
	if upgraded == false:
		var upgrade_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		upgrade_tween.tween_property(sprite,"scale", Vector2(0,1), 0.1)
		sprite.frame = frame
		upgrade_tween.tween_property(sprite,"scale", Vector2(1,1), 0.1)
		upgraded = true
		SignalManager.emit_console_label(self.nametag + ' has been promoted!' , Global.ORANGE)
		match type:
			'Grunt':
				tiles_moved = 2
				multiply_raycast_length(2)

