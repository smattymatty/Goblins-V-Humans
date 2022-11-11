extends Node2D

var turns_since_goblin = 0
var turns_since_human = 0
var available_powerups:Array = []

onready var left: Node2D = $left
onready var right: Node2D = $right
onready var powerups: Node2D = $powerups
onready var entities: Node2D = $"%Entities"
onready var effects: Node2D = $"%Effects"

func _ready() -> void:
	spawn_goblin_grunt()
	spawn_human_grunt()
	available_powerups = populate_powerups()
	TurnManager.connect("turn_passed",self,'_turn_start')
	SignalManager.connect("spawn_goblin",self,'spawn_goblin_grunt')
	SignalManager.connect('spawn_human',self,'spawn_human_grunt')
	
func _turn_start() -> void:
	turns_since_goblin += 1
	turns_since_human += 1
	var powerup_positions = powerups.get_children()
	for i in powerup_positions:
		i.move_randomly(['Left','Right','Up','Down'])
	spawn_random_powerup()
	if turns_since_goblin > 2: 
		var random_number = round(rand_range(1,100) ) + (turns_since_goblin * 10)
		print('random goblin number: ', random_number)
		if random_number >= 100:
			spawn_goblin_grunt()
	if turns_since_human > 2: 
		var random_number = round(rand_range(1,100))  + (turns_since_human * 10)
		print('random human number: ', random_number)
		if random_number >= 100:
			spawn_human_grunt()
		
	
func spawn_human_grunt() -> void:
	var positions = left.get_children()
	var human_grunt = load("res://scenes/enemies/grunt.tscn")
	var human_grunt_instance = human_grunt.instance()
	positions.shuffle()
	var spawnpoint = positions[0]  as SpawnPoint
	human_grunt_instance.add_to_group('enemy')
	human_grunt_instance.add_to_group('human')
	var times_checked:int = 0
	for i in positions:
		if i.active == true:
			spawnpoint = i
			spawnpoint.spawn(human_grunt_instance,entities)
			break
		else:
			times_checked +=1
		if times_checked == positions.size():
			print('-!-!ERROR!-!- ALL SPAWNPOINTS ARE DEACTIVATED!')
			break
	turns_since_human = 0
	
func spawn_goblin_grunt() -> void:
	var positions = right.get_children()
	var goblin_grunt = load("res://scenes/enemies/grunt.tscn")
	var goblin_grunt_instance = goblin_grunt.instance()
	positions.shuffle()
	var spawnpoint = positions[0] as SpawnPoint
	goblin_grunt_instance.add_to_group('enemy')
	goblin_grunt_instance.add_to_group('goblin')
	var times_checked:int = 0
	for i in positions:
		if i.active == true:
			spawnpoint = i
			spawnpoint.spawn(goblin_grunt_instance,entities)
			break
		else:
			times_checked +=1
		if times_checked == positions.size():
			print('-!-!ERROR!-!- ALL SPAWNPOINTS ARE DEACTIVATED!')
			break
	turns_since_goblin = 0
			
func spawn_random_powerup() -> void:
	available_powerups.shuffle()
	var powerup_instance = available_powerups[0].instance()
	var positions = powerups.get_children()
	positions.shuffle()
	var spawnpoint
	var times_checked = 0
	for i in positions:
		if i.active == true:
			spawnpoint = i
			spawnpoint.spawn(powerup_instance, effects)
			break
		else:
			times_checked +=1
		if times_checked == positions.size():
			print('-!-!ERROR!-!- ALL SPAWNPOINTS ARE DEACTIVATED')

func populate_powerups() -> Array:
	var base = load("res://scenes/items/powerups/base_powerup.tscn")
	var health = load("res://scenes/items/powerups/health_powerup.tscn")
	var damage = load("res://scenes/items/powerups/damage_powerup.tscn")
	var defense = load("res://scenes/items/powerups/defense_powerup.tscn")
	return[base,health,damage,defense]
