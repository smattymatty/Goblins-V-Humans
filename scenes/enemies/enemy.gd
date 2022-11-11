class_name Enemy

extends Character

export(Resource) var stats = stats as EnemyStats
export(Resource) var info


func _ready() -> void:
	SignalManager.connect("update_time_to_move",self,"update_time_to_move")
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
	if speeds_array.size() > 0:
		var new_time:float = 2/(float(speeds_array.size()))
		time_to_move = clamp(new_time, 0.02,0.2)
