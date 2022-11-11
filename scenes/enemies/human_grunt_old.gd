extends Enemy


func _enter_tree() -> void:
	nametag = str(shuffle_grab(info.human_names,0) + ' the ' + stats.nametag)

func _turn_start() -> void:
	if on_death_fog:
		take_fog_damage()
	if STATE != STATES.IN_COMBAT:
		set_state(PREV_STATE)
	times_attacked = 0
	if SignalManager.debug_level > 4:
		print('TURN START: ', self.nametag, ' in state ', str(self.STATE))
	match STATE:
		STATES.FREE:
			check_for_enemies(preferred_directions,false)
			if STATE == STATES.FREE:
				check_ground_and_move()
		STATES.IN_COMBAT:
			if animation.is_playing():
				yield(animation,"animation_finished")
			if times_attacked == 0:
				check_for_enemies(preferred_directions,false) # sets state back to free if there are no enemies
				if STATE == STATES.FREE:
					print('state is free after in_combat')
					check_ground_and_move()
			
func check_ground_and_move() -> void:
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
				preferred_directions = ['Left','Down','Up','Right'] # Upgraded Now prefers [0]
			else:
				check_for_movement(preferred_directions,false,0)
