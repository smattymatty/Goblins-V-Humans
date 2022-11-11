extends Node2D

var mouse_targeted 

onready var canvas: CanvasLayer = $"%Canvas"
onready var tile_map: TileMap = $"%TileMap"
onready var mouse_area: Area2D = $mouse_area
onready var mouseover_timer: Timer = $"%mouseover_timer"
onready var camera: Camera2D = $"%Camera2D"

func _ready() -> void:
	SignalManager.connect("entered_door",self,'enter_house')
	TurnManager.connect("turn_passed",self,'_turn_passed')
	randomize()

func _turn_passed():
	if TurnManager.death_fog_is_active == true:
		pass
		

func _process(_delta: float) -> void:
	mouse_area.global_position = get_global_mouse_position()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("r_click") and mouse_targeted != null:
#		instance_r_click_menu(mouse_targeted)
		pass
	elif event.is_action_pressed("r_click") and mouse_targeted == null:
		print('you need a target')
		

func _on_mouse_area_area_entered(area: Area2D) -> void:
	mouse_targeted = area.get_parent()
#	yield(mouseover_timer, 'timeout')
#	if area.get_parent().is_in_group('enemy') or area.get_parent().is_in_group('player'):
#		instance_overhead_stats(area.get_parent())

func _on_mouse_area_area_exited(_area: Area2D) -> void:
	mouse_targeted = null
#	SignalManager.emit_mouse_left_target_area(area.get_parent())

func enter_house() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera,'offset',Vector2(257,-190),2.0)
	var tween2 = create_tween().set_trans(Tween.TRANS_EXPO)
	tween2.tween_property(camera,'zoom',Vector2(0.5,0.5),2.0)
	


func _on_left_ground_body_entered(body: Node) -> void:
	if body.is_in_group('goblin'):
		body.on_ground = 'Enemy'
	elif body.is_in_group('human'):
		body.on_ground = 'Ally'

func _on_left_ground_body_exited(body: Node) -> void:
	pass
		
func _on_center_area_body_entered(body: Node) -> void:
	if body.is_in_group('enemy'):
		body.on_ground = 'Center'

func _on_center_area_body_exited(body: Node) -> void:
	pass

func _on_right_ground_body_entered(body: Node) -> void:
	if body.is_in_group('human'):
		body.on_ground = 'Enemy'
	elif body.is_in_group('goblin'):
		body.on_ground = 'Ally'

func _on_right_ground_body_exited(body: Node) -> void:
	pass
	
