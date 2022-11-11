extends Control

onready var hp_label: Label = $"%hp_label"
onready var dmg_label: Label = $"%dmg_label"
onready var def_label: Label = $"%def_label"
onready var spd_label: Label = $"%spd_label"
onready var pierce_label: Label = $"%pierce_label"
onready var phys_res_label: Label = $"%phys_res_label"
onready var fire_res_label: Label = $"%fire_res_label"
onready var ice_res_label: Label = $"%ice_res_label"
onready var lightning_res_label: Label = $"%lightning_res_label"
onready var phys_dmg_label: Label = $"%phys_dmg_label"
onready var fire_dmg_label: Label = $"%fire_dmg_label"
onready var ice_dmg_label: Label = $"%ice_dmg_label"
onready var lightning_dmg_label: Label = $"%lightning_dmg_label"
onready var mana_label: Label = $"%mana_label"
onready var stats_container: GridContainer = $"%statscontainer"
onready var boost_label: Label = $"%boost_label"
onready var debuff_label: Label = $"%debuff_label"
onready var weapon_dmg_label: Label = $"%weapon_dmg_label"
onready var skill_dmg_label: Label = $"%skill_dmg_label"


func _ready() -> void:
	hide_all()
	
func hide_all() -> void:
	for i in stats_container.get_children():
		i.find_node('stat_info').hide()

func _on_hp_label_mouse_entered() -> void:
	hp_label.find_node('stat_info').show()

func _on_hp_label_mouse_exited() -> void:
	hp_label.find_node('stat_info').hide()

func _on_mana_label_mouse_entered() -> void:
	mana_label.find_node('stat_info').show()

func _on_mana_label_mouse_exited() -> void:
	mana_label.find_node('stat_info').hide()

func _on_dmg_label_mouse_entered() -> void:
	dmg_label.find_node('stat_info').show()

func _on_dmg_label_mouse_exited() -> void:
	dmg_label.find_node('stat_info').hide()

func _on_def_label_mouse_entered() -> void:
	def_label.find_node('stat_info').show()

func _on_def_label_mouse_exited() -> void:
	def_label.find_node('stat_info').hide()

func _on_spd_label_mouse_entered() -> void:
	spd_label.find_node('stat_info').show()

func _on_spd_label_mouse_exited() -> void:
	spd_label.find_node('stat_info').hide()

func _on_pierce_label_mouse_entered() -> void:
	pierce_label.find_node('stat_info').show()

func _on_pierce_label_mouse_exited() -> void:
	pierce_label.find_node('stat_info').hide()
	



func _on_phys_res_label_mouse_entered() -> void:
	phys_res_label.find_node('stat_info').show()


func _on_phys_res_label_mouse_exited() -> void:
	phys_res_label.find_node('stat_info').hide()


func _on_fire_res_label_mouse_entered() -> void:
	fire_res_label.find_node('stat_info').show()


func _on_fire_res_label_mouse_exited() -> void:
	fire_res_label.find_node('stat_info').hide()


func _on_ice_res_label_mouse_entered() -> void:
	ice_res_label.find_node('stat_info').show()


func _on_ice_res_label_mouse_exited() -> void:
	ice_res_label.find_node('stat_info').hide()


func _on_lightning_res_label_mouse_entered() -> void:
	lightning_res_label.find_node('stat_info').show()


func _on_lightning_res_label_mouse_exited() -> void:
	lightning_res_label.find_node('stat_info').hide()


func _on_phys_dmg_label_mouse_entered() -> void:
	phys_dmg_label.find_node('stat_info').show()


func _on_phys_dmg_label_mouse_exited() -> void:
	phys_dmg_label.find_node('stat_info').hide()

func _on_fire_dmg_label_mouse_entered() -> void:
	fire_dmg_label.find_node('stat_info').show()

func _on_fire_dmg_label_mouse_exited() -> void:
	fire_dmg_label.find_node('stat_info').hide()


func _on_ice_dmg_label_mouse_entered() -> void:
	ice_dmg_label.find_node('stat_info').show()


func _on_ice_dmg_label_mouse_exited() -> void:
	ice_dmg_label.find_node('stat_info').hide()


func _on_lightning_dmg_label_mouse_entered() -> void:
	lightning_dmg_label.find_node('stat_info').show()


func _on_lightning_dmg_label_mouse_exited() -> void:
	lightning_dmg_label.find_node('stat_info').hide()


func _on_boost_label_mouse_entered() -> void:
	boost_label.find_node('stat_info').show()


func _on_boost_label_mouse_exited() -> void:
	boost_label.find_node('stat_info').hide()

func _on_debuff_label_mouse_entered() -> void:
	debuff_label.find_node('stat_info').show()

func _on_debuff_label_mouse_exited() -> void:
	debuff_label.find_node('stat_info').hide()


func _on_weapon_dmg_label_mouse_entered() -> void:
	weapon_dmg_label.find_node('stat_info').show()


func _on_weapon_dmg_label_mouse_exited() -> void:
	weapon_dmg_label.find_node('stat_info').hide()
