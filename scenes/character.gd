class_name Character
extends KinematicBody2D

var nametag:String 
var speed
var max_hp
var hp
var damage
var damage_type
var defense
var defense_pierce
var physical_resist
var fire_resist
var ice_resist
var lightning_resist
var physical_damage
var fire_damage
var ice_damage
var lightning_damage
var weapon_damage_multi
var skill_damage
var boost_multi
var debuff_multi

var is_moving:bool = false
var moves_per_turn:int = 3
var moved_last_turn:bool = false
var remaining_moves:int = 3
var attacks_per_turn:int = 1
var time_to_move:float = 0.2
var raycast_length:float = 32
var turn_state:String # determines whether or not it can move
var combat_state:String # determines whether or not it should check for enemies before movement
var directions:Array = ['Left','Right','Up','Down']
var collider
var on_ground:String
var has_overhead_stats:bool = false

var powerups:Dictionary

onready var debug_label: Label = $"%debug_label"
onready var timer: Timer = $"%Timer"
onready var raycast: RayCast2D = $"%raycast"
onready var overhead: Position2D = $"%overhead_stats_position"
onready var target_indicator: Sprite = $"%target_indicator"
onready var animation: AnimationPlayer = $"%AnimationPlayer"
onready var sprite: Sprite = $"%Sprite"
onready var overhead_label: PackedScene = load("res://scenes/UI/overhead_label.tscn")
onready var raycasts: Array = $"%raycasts".get_children()

func _turn_end() -> void: # should be overidden by seperate scripts
	pass 
	
func set_state(type:String, state) -> void:
	match type:
		"Turn":
			turn_state = state
		"Combat":
			combat_state = state
			
func _process(_delta: float) -> void:
	if is_instance_valid(self):
		if target_indicator.visible == true and has_overhead_stats == false:
			yield(get_tree().create_timer(1.0),'timeout')
			if target_indicator.visible == true and has_overhead_stats == false:
				instance_overhead_stats(self)
				has_overhead_stats = true
		if target_indicator.visible == false and has_overhead_stats == true:
			SignalManager.emit_hard_remove_overhead_stats(self)
			has_overhead_stats = false
		if SignalManager.debug_level > 1 and debug_label.visible == false:
			debug_label.show()
		
		

func _on_target_area_area_entered(area: Area2D) -> void:
	if self.is_in_group('death fog') == false and is_instance_valid(self):
		target_indicator.show()
		SignalManager.emit_mouse_entered_target_area(self)
		area.mouseover_timer.start(0.5)
		yield(area.mouseover_timer,'timeout')
		instance_overhead_stats(self)

func _on_target_area_area_exited(area: Area2D) -> void:
	if is_instance_valid(self):
		area.mouseover_timer.stop()
		target_indicator.hide()
		SignalManager.emit_mouse_left_target_area(self)
		
func instance_overhead_stats(target) -> void:
	var overhead_stats = load("res://scenes/UI/overhead_stats.tscn")
	var overhead_stats_instance = overhead_stats.instance()
	overhead_stats_instance.rect_position = target.overhead.position
	overhead_stats_instance.stored_target = target
	overhead_stats_instance.update_stats(target)
	SignalManager.emit_overhead_stats(target, overhead_stats_instance)

func set_raycast_to(direction:String) -> void:
	match direction:
		'Left':
			raycast.cast_to = Vector2(-raycast_length,0)
		'Right':
			raycast.cast_to = Vector2(raycast_length,0)
		'Down':
			raycast.cast_to = Vector2(0,raycast_length)
		'Up':
			raycast.cast_to = Vector2(0,-raycast_length)

func multiply_raycast_length(amount:float) -> void:
	raycast_length *= amount
	for i in raycasts:
		i.cast_to *= amount
	
func check_and_set_collider(raycaster) -> bool:
	if raycaster.is_colliding():
		collider = raycaster.get_collider()
		return true
	else:
		collider = null
		return false
		
func shuffle_grab(array:Array) -> bool:
	array.shuffle()
	var grabbed = array[0]
	array.remove(0)
	return grabbed

func move(direction:String,tiles:int):
	remaining_moves -= 1
	if SignalManager.debug_level > 3:
		print(self.nametag + ' has moved ' + str(tiles) + ' to direction: ' + direction, ' moves left: ', remaining_moves)
	var movement_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	var target_location:Vector2
	is_moving = true
	match direction:
		'Left':
			target_location = self.position + (Vector2(-32,0) * tiles)
			movement_tween.tween_property(self,"position",target_location,time_to_move)
		'Right':
			target_location = self.position + (Vector2(32,0) * tiles)
			movement_tween.tween_property(self,"position",target_location,time_to_move)
		'Up':
			target_location = self.position + (Vector2(0,-32) * tiles)
			movement_tween.tween_property(self,"position",target_location,time_to_move)
		'Down':
			target_location = self.position + (Vector2(0,32) * tiles)
			movement_tween.tween_property(self,"position",target_location,time_to_move)
	yield(movement_tween,"finished")
	is_moving = false
	check_remaining_moves()
	
func cant_move() -> void:
	moved_last_turn = false
	randomize()
	remaining_moves -= 1
	var movement_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	var target_down = self.position + Vector2(-2,5)
	var target_up = self.position + Vector2(2,-5)
	var target_left = self.position + Vector2(-5,2)
	var target_right = self.position + Vector2(5,-2)
	var targets:Array = [target_up,target_down,target_left,target_right]
	targets.shuffle()
	var target_original = self.position
	is_moving = true
	movement_tween.tween_property(self,"position",targets[0],time_to_move/3)
	movement_tween.tween_property(self,"position",targets[1],time_to_move/3)
	movement_tween.tween_property(self,"position",target_original,time_to_move/3)
	yield(movement_tween,"finished")
	is_moving = false
	if self.is_in_group('player'):
		_turn_end()
	else:
		check_remaining_moves()
	
func check_remaining_moves() -> void:
	handle_move_combat()
	moved_last_turn = true
	if remaining_moves <= 0:
		_turn_end() 

func set_debug_label(text):
	debug_label.text = str(text)

func attack(direction:String,target) -> void:
	if SignalManager.debug_level > 3:
		print('--Attack-- ', self.nametag, ' attacked ', target, ' in direction: ', direction)
	set_state('Combat','In Combat')
	if self.is_in_group('player'):
		animation.queue('Attack'+direction)
		target.calculate_damage((self.stats.base_damage + self.stats.weapon_damage),
		self.stats.weapon_damage_type,self)
		if target.hp <= 0:
			set_state('Combat','Out of Combat')
	if self.is_in_group('enemy'):
		animation.queue('Attack'+direction)
		target.calculate_damage(self.damage,self.stats.damage_type,self)
		if target.is_in_group('player'):
			if target.stats.hp <= 0:
				set_state('Combat','Out of Combat')
		elif target.is_in_group('enemy'):
			if target.hp <= 0:
				set_state('Combat','Out of Combat')
	yield(animation,'animation_finished')
	moved_last_turn = false
	_turn_end()

func calculate_damage(amount,type,damager) -> void:
	set_state('Combat','In Combat')
	var damage_after_defense
	var total_damage
	if self.is_in_group('player'):
		damage_after_defense = amount - (self.stats.defense - damager.defense_pierce)
		match type:
			'Physical':
				total_damage = round(damage_after_defense * self.stats.physical_resist)
			'Fire':
				total_damage = round(damage_after_defense * self.stats.fire_resist)
			'Ice':
				total_damage = round(damage_after_defense * self.stats.ice_resist)
			'Lightning':
				total_damage = round(damage_after_defense * self.stats.lightning_resist)
		SignalManager.emit_console_label(damager.nametag + ' has dealt ' + str(clamp(total_damage, 1, 9999)) + 
		" to " + self.nametag, Color.white)
		self.stats.hp -= clamp(total_damage, 1, 9999)
		if self.stats.hp <= 0:
			die()
	if self.is_in_group('enemy'):
		damage_after_defense = amount - (self.defense - damager.defense_pierce)
		match type:
			'Physical':
				total_damage = round(damage_after_defense * self.physical_resist)
			'Fire':
				total_damage = round(damage_after_defense * self.fire_resist)
			'Ice':
				total_damage = round(damage_after_defense * self.ice_resist)
			'Lightning':
				total_damage = round(damage_after_defense * self.lightning_resist)
		SignalManager.emit_console_label(damager.nametag + ' has dealt ' + str(total_damage) + 
		" to " + self.nametag, Color.white)
		self.hp -= clamp(total_damage, 1, 9999)
		if self.hp < 0:
			die()
	
func die() -> void:
	SignalManager.emit_enemy_died(self)
	queue_free()
		
func moveup() -> void: # for the door entrance
	yield(get_tree().create_timer(1.0),'timeout')
	var movement_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
	var target_location:Vector2
	target_location = self.position + (Vector2(0,-32) * 1)
	movement_tween.tween_property(self,"position",target_location,time_to_move)
	SignalManager.emit_moved_up()
	
func collect_powerup(function) -> void:
	var label_instance = overhead_label.instance()
	var label_instance_2 = overhead_label.instance()
	match function:
		'+ 1 basic stats':
			if 'basic_stats' in powerups:
				powerups['basic_stats']['value'] += 1
			else:
				powerups['basic_stats'] = {'name':'Basic Boost', 'value':1, 'turns_left':-1}
			if self.is_in_group('player'):
				label_instance.set_text('+'+str(round(1 * self.stats.boost_multi))+' BASE STATS', 
				Global.YELLOW, 1.0)
				self.stats.max_hp += round(1 * self.stats.boost_multi)
				self.stats.hp += round(1 * self.stats.boost_multi)
				self.stats.speed += round(1 * self.stats.boost_multi)
				self.stats.defense += round(1 * self.stats.boost_multi)
				self.stats.base_damage += round(1 * self.stats.boost_multi)
			elif self.is_in_group('enemy'):
				label_instance.set_text('+'+str(round(1 * self.boost_multi))+' BASE STATS',
				Global.YELLOW, 1.0)
				max_hp += round(1 * self.boost_multi)
				hp += round(1 * self.boost_multi)
				speed += round(1 * self.boost_multi)
				defense += round(1 * self.boost_multi)
				damage += round(1 * self.boost_multi)
				
		'health boost':
			if 'health_boost' in powerups:
				powerups['health_boost']['value'] += 2
			else:
				powerups['health_boost'] = {'name':'Health Boost','value':1, 'turns_left':-1}
			if self.is_in_group('player'):
				label_instance.set_text('+'+str(round(2 * self.stats.boost_multi))+' MAX HP', 
				Global.YELLOW, 1.0)
				self.stats.max_hp += round(2 * self.stats.boost_multi)
				self.stats.hp += round(2 * self.stats.boost_multi)
			elif self.is_in_group('enemy'):
				label_instance.set_text('+'+str(round(2 * self.boost_multi))+' MAX HP',
				 Global.YELLOW, 1.0)
				max_hp += round(2 * self.boost_multi)
				hp += round(2 * self.stats.boost_multi)
				
		'+ 2 damage stats':
			if 'damage_boost' in powerups:
				powerups['damage_boost']['value'] += 2
			else:
				powerups['damage_boost'] = {'name':'Damage Boost','value':1, 'turns_left':-1}
			if self.is_in_group('player'):
				label_instance.set_text('+'+str(round(2 * self.stats.boost_multi))+' DAMAGE STATS', 
				Global.YELLOW, 1.0)
				self.stats.base_damage += round(2 * self.stats.boost_multi)
				self.stats.physical_damage += stepify((0.02 * self.stats.boost_multi),0.01)
				self.stats.fire_damage += stepify((0.02 * self.stats.boost_multi),0.01)
				self.stats.ice_damage += stepify((0.02 * self.stats.boost_multi),0.01)
				self.stats.lightning_damage += stepify((0.02 * self.stats.boost_multi),0.01)
				self.stats.weapon_damage += stepify((0.02 * self.stats.boost_multi),0.01)
				self.stats.skill_damage += stepify((0.02 * self.stats.boost_multi),0.01)
			elif self.is_in_group('enemy'):
				label_instance.set_text('+'+str(round(2 * self.boost_multi))+' DAMAGE STATS',
				 Global.YELLOW, 1.0)
				damage += round(2 * self.boost_multi)
				physical_damage += stepify((0.02 * self.boost_multi),0.01)
				fire_damage += stepify((0.02 * self.boost_multi),0.01)
				ice_damage += stepify((0.02 * self.boost_multi),0.01)
				lightning_damage += stepify((0.02 * self.boost_multi),0.01)
				weapon_damage_multi += stepify((0.02 * self.boost_multi),0.01)
				skill_damage += stepify((0.02 * self.boost_multi),0.01)
				
		'+ 2 defense stats':
			if 'defense_boost' in powerups:
				powerups['defense_boost']['value'] += 2
			else:
				powerups['defense_boost'] = {'name':'Defense Boost','value':1, 'turns_left':-1}
			if self.is_in_group('player'):
				label_instance.set_text('+'+str(round(2 * self.stats.boost_multi))+' DEFENSE STATS', 
				Global.YELLOW, 1.0)
				self.stats.defense  += round(2 * self.stats.boost_multi)
				self.stats.physical_resist -= stepify((0.02 * self.stats.boost_multi),0.01)
				self.stats.fire_resist -= stepify((0.02 * self.stats.boost_multi),0.01)
				self.stats.ice_resist -= stepify((0.02 * self.stats.boost_multi),0.01)
				self.stats.lightning_resist -= stepify((0.02 * self.stats.boost_multi),0.01)
			elif self.is_in_group('enemy'):
				label_instance.set_text('+'+str(round(2 * self.boost_multi))+' DEFENSE STATS',
				 Global.YELLOW, 1.0)
				self.defense  += round(2 * self.boost_multi)
				self.physical_resist -= stepify((0.02 * self.boost_multi),0.01)
				self.fire_resist -= stepify((0.02 * self.boost_multi),0.01)
				self.ice_resist -= stepify((0.02 * self.boost_multi),0.01)
				self.lightning_resist -= stepify((0.02 * self.boost_multi),0.01)
	label_instance.set_position(self)
	self.add_child(label_instance)
#	if label_instance_2.check_if_null() == false:
	label_instance_2.set_position(self)
	self.add_child(label_instance_2)
	if SignalManager.debug_level > 3:
		print(self.nametag, ' powerups dictionary: ', str(powerups))

func handle_move_combat() -> void:
	if moved_last_turn == true:
		set_state('Combat','Out of Combat')
	else:
		pass
