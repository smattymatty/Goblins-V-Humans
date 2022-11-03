extends Enemy


func _enter_tree() -> void:
	preferred_directions = ['Left','Down','Up','Right']
	nametag = str(shuffle_grab(info.goblin_names,0) + ' the ' + stats.nametag)


func _turn_start() -> void:
	match STATE:
		STATES.FREE:
			match on_ground:
				'Ally':
					check_for_movement(preferred_directions,false,0)
				'Center':
					if is_upgraded == false:
						check_for_movement(preferred_directions,false,0)
					else:
						check_for_movement(preferred_directions,true,0)
				'Enemy':
					if is_upgraded == false:
						upgrade()
						preferred_directions = ['Right','Down','Up','Left'] # Upgraded Now prefers [0]
					else:
						check_for_movement(preferred_directions,false,0)
		STATES.IN_COMBAT:
			check_for_enemies(preferred_directions,false) # sets state back to free if there are no enemies
			
		
