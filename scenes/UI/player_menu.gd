extends Control

onready var inventory: Control = $"%Inventory"
onready var character: Control = $"%Character"
onready var character_tab: Control = $"%character_tab"
onready var inventory_tab: Control = $"%inventory_tab"

func _ready() -> void:
	character_tab.connect("button_pressed",self,'open_character_sheet')
	inventory_tab.connect('button_pressed',self,'open_inventory')
	self.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("character sheet"):
		if self.is_visible_in_tree() == false or inventory.is_visible_in_tree() == true:
			open_character_sheet()
		elif character.is_visible_in_tree() == true:
			self.hide()
			get_tree().paused = false
	elif event.is_action_pressed("inventory"):
		if self.is_visible_in_tree() == false or character.is_visible_in_tree() == true:
			open_inventory()
		elif inventory.is_visible_in_tree() == true:
			self.hide()
			get_tree().paused = false
			
func open_character_sheet() -> void:
	character.update_player_stats()
	character.update_active_effects()
	get_tree().paused = true
	inventory_tab.revert_colors()
	character_tab.invert_colors()
	self.show()
	inventory.hide()
	character.show()

func open_inventory() -> void:
	get_tree().paused = true
	character_tab.revert_colors()
	inventory_tab.invert_colors()
	self.show()
	inventory.show()
	character.hide()
