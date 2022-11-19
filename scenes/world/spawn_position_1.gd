class_name SpawnPoint

extends Position2D

var move_options:Array = [32, 64, 96]
var moved = false
var active = true
var turns_left = 0
var powerup_points = [Vector2(272,208), Vector2(753,208), Vector2(752,336), Vector2(272,336), Vector2(496,336), Vector2(496,176)]

func _ready() -> void:
	randomize()
	TurnManager.connect("turn_passed",self,'count_turns')
	
func deactivate(turns) -> void:
	active = false
	turns_left += turns
	$Label.text = str(turns_left)
	
func count_turns() -> void:
	powerup_points = [Vector2(272,208), Vector2(753,208), Vector2(752,336), Vector2(272,336), Vector2(496,336), Vector2(496,176)]
	if turns_left > 0:
		turns_left -=1
		$Label.text = str(turns_left)
	else:
		active = true

func spawn(instance,node) -> void:
	fix_position()
	instance.position = self.position
	node.add_child(instance)
	deactivate(3)
	if SignalManager.debug_level > 4:
		print('---', instance.nametag, '--- Spawned at position: ', self.position)

func move_randomly(directions) -> void:
	moved = true
	directions.shuffle()
	move_options.shuffle()
	match directions[0]:
		'Left':
			self.position.x -= move_options[0]
		'Right':
			self.position.x += move_options[0]
		'Up':
			self.position.y -= move_options[0]
		'Down':
			self.position.y += move_options[0]
		
func _process(delta: float) -> void:
	fix_position()

func _on_Area2D_body_entered(body: Node) -> void:
	deactivate(2)
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	deactivate(2)
	if moved == true:
		move_randomly(['Left','Right','Up','Down'])
 
func fix_position() -> void:
	if moved == true:
		if self.position.x < 144 or position.x > 880 or position.y < 48 or position.y > 432:
			powerup_points.shuffle()
			self.position = powerup_points[0]
			powerup_points.remove(0)
