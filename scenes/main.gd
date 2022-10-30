extends Node2D

var mouse_targeted 

onready var mouse_area: Area2D = $mouse_area
onready var mouseover_timer: Timer = $"%mouseover_timer"

func _process(delta: float) -> void:
	mouse_area.global_position = get_global_mouse_position()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("r_click") and mouse_targeted != null:
#		instance_r_click_menu(mouse_targeted)
		pass
	elif event.is_action_pressed("r_click") and mouse_targeted == null:
		print('you need a target')
		

func _on_mouse_area_area_entered(area: Area2D) -> void:
	mouseover_timer.start(0.5)
	mouse_targeted = area
	mouse_targeted = area.get_parent()
	yield(mouseover_timer, 'timeout')
	instance_overhead_stats(mouse_targeted)
	


func _on_mouse_area_area_exited(area: Area2D) -> void:
	mouseover_timer.stop()
	mouse_targeted = null

func instance_overhead_stats(target) -> void:
	var overhead_stats = load("res://scenes/UI/overhead_stats.tscn")
	var overhead_stats_instance = overhead_stats.instance()
	target.add_child(overhead_stats_instance)
	

#func instance_r_click_menu(target) -> void:
#	var r_click_menu = load("res://scenes/UI/r_click_menu.tscn")
#	var r_click_menu_instance = r_click_menu.instance()
#	r_click_menu_instance.rect_position = target.global_position
#	add_child(r_click_menu_instance)


func _on_left_ground_body_entered(body: Node) -> void:
	if body.is_in_group('goblin'):
		body.on_enemy_ground = true
		print('goblin entered area')

func _on_left_ground_body_exited(body: Node) -> void:
	if body.is_in_group('goblin'):
		body.on_enemy_ground = false

func _on_center_area_body_entered(body: Node) -> void:
	if body.is_in_group('enemy'):
		body.on_center_ground = true

func _on_center_area_body_exited(body: Node) -> void:
	if body.is_in_group('enemy'):
		body.on_center_ground = false

func _on_right_ground_body_entered(body: Node) -> void:
	if body.is_in_group('human'):
		body.on_enemy_ground = true

func _on_right_ground_body_exited(body: Node) -> void:
	if body.is_in_group('human'):
		body.on_enemy_ground = false
