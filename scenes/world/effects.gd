extends Node2D

var death_fog_activated:int = 0

onready var entities: Node2D = $"%Entities"
onready var tile_map: TileMap = $"%TileMap"
onready var fog_location_array = [Vector2(80,432), Vector2(944,432), Vector2(80,48), Vector2(944,48)]

func _ready() -> void:
	randomize()
#	TurnManager.connect("turn_passed",self,"_on_turn_passed")
	
#func _unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("click"):
#		print(str(get_global_mouse_position()))

#func _on_turn_passed() -> void:
#	if TurnManager.death_fog_is_active and death_fog_activated == 0:
#		shuffle_locations_and_spawn(2)
#	if TurnManager.death_fog_overtime and death_fog_activated == 1:
#		shuffle_locations_and_spawn(2)
	
func shuffle_locations_and_spawn(amount) -> void:
	fog_location_array.shuffle()
	for _i in range(amount):
		instance_death_fog(fog_location_array[0])
		fog_location_array.remove(0)
	death_fog_activated += 1
		
func instance_death_fog(location) -> void:
	var death_fog = load("res://scenes/world/death_fog.tscn")
	var death_fog_instance = death_fog.instance()
	death_fog_instance.global_position = location
	add_child(death_fog_instance)
	
	
