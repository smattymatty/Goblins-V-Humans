extends Character

export(Resource) var stats = stats as PlayerStats

var mouse_pos:Vector2
var mouse_direction:String

onready var movement_indicator: Sprite = $"%movement_indicator"

func _ready() -> void:
	SignalManager.connect("entered_door",self,'moveup')
	set_state('Combat','Out of Combat')
	stats.mana = stats.max_mana
	stats.hp = stats.max_hp
	nametag = stats.nametag
	speed = stats.speed

func _turn_start() -> void:
	speed = stats.speed
	turn_state = 'Active'
	match combat_state:
		'Out of Combat':
			remaining_moves = moves_per_turn
		'In Combat':
			remaining_moves = 1
			
func _unhandled_input(event: InputEvent) -> void:
	match turn_state:
		"Active":
			if event is InputEventMouseMotion:
				movement_indicator_on_mouse()
			
			if event.is_action_pressed("ui_left") and is_moving == false:
				check_and_move_or_attack('Left')
			elif event.is_action_pressed("ui_right") and is_moving == false:
				check_and_move_or_attack('Right')
			elif event.is_action_pressed("ui_up") and is_moving == false:
				check_and_move_or_attack('Up')
			elif event.is_action_pressed("ui_down") and is_moving == false:
				check_and_move_or_attack('Down')
			elif event.is_action_pressed("click") and is_moving == false:
				check_and_move_or_attack(mouse_direction)
			elif event.is_action_pressed("end_turn") and is_moving == false:
				cant_move()
				
func _process(delta: float) -> void:
	stats.powerups = powerups
	if is_moving == true or turn_state != "Active":
		movement_indicator.hide()
	else:
		movement_indicator.show()
	if stats.hp > stats.max_hp:
		stats.hp = stats.max_hp
	
func _turn_end() -> void:
	set_state('Turn','Inactive')
	TurnManager.player_turn_finished()
		
func movement_indicator_on_mouse() -> void:
	mouse_pos = get_global_mouse_position()
	var mouse_direction_to = mouse_pos.direction_to(self.global_position).round()
#	if mouse_pos.y - self.global_position.y < 16 and mouse_pos.y - self.global_position.y > -16:
	if mouse_direction_to == Vector2.RIGHT:
		movement_indicator.global_position = self.global_position + Vector2(-32,0)
		mouse_direction = 'Left'
	elif mouse_direction_to == Vector2.LEFT:
		movement_indicator.global_position = self.global_position + Vector2(32,0)
		mouse_direction = 'Right'
#	elif mouse_pos.x - self.global_position.x > -640 or mouse_pos.x - self.global_position.x < 640:		
	elif mouse_direction_to == Vector2.DOWN:
		movement_indicator.global_position = self.global_position + Vector2(0,-32)
		mouse_direction = 'Up'
	elif mouse_direction_to == Vector2.UP:
		movement_indicator.global_position = self.global_position + Vector2(0,32)
		mouse_direction = 'Down'
		
func check_and_move_or_attack(direction) -> void:
	set_raycast_to(direction)
	yield(get_tree(),"idle_frame")
	if check_and_set_collider() == false:
		move(direction, 1)
	elif check_and_set_collider() == true:
		if collider.is_in_group('enemy'):
			attack(direction,collider)
		elif collider.is_in_group('powerup'):
			move(direction,1)
