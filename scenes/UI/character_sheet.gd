extends Control

export(Resource) var stats = stats as PlayerStats

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
onready var weapon_dmg_label: Label = $"%weapon_dmg_label"
onready var skill_dmg_label: Label = $"%skill_dmg_label"
onready var boost_label: Label = $"%boost_label"
onready var debuff_label: Label = $"%debuff_label"

var is_for:String = 'player'

func _ready() -> void:
	if is_for == 'player':
		update_player_stats()
		update_active_effects()

func update_player_stats() -> void:
	hp_label.text = 'Health Points: ' + str(stats.hp) + '/' + str(stats.max_hp)
	mana_label.text = 'Mana Points: ' + str(stats.mana) + '/' + str(stats.max_mana)
	dmg_label.text = 'Base Damage: ' + str(stats.base_damage)
	def_label.text = "Defense: " + str(stats.defense)
	spd_label.text = 'Speed: ' + str(stats.speed)
	pierce_label.text = 'Pierce: ' + str(stats.defense_pierce)
	phys_res_label.text = 'Phys Resist: ' + str((1-(stats.physical_resist))*100) + "%"
	fire_res_label.text = 'Fire Resist: ' + str((1-(stats.fire_resist))*100) + "%"
	ice_res_label.text = 'Ice Resist: ' + str((1-(stats.ice_resist))*100) + "%"
	lightning_res_label.text = 'Lghtng Resist: ' + str((1-(stats.lightning_resist))*100) + "%"
	phys_dmg_label.text = "Phys Damage: " + str((stats.physical_damage - 1)*100) + '%'
	fire_dmg_label.text = "Fire Damage: " + str((stats.fire_damage - 1)*100) + '%'
	ice_dmg_label.text = "Ice Damage: " + str((stats.ice_damage - 1)*100) + '%'
	lightning_dmg_label.text = "Lghtng Damage: " + str((stats.lightning_damage - 1)*100) + '%'
	weapon_dmg_label.text = "Weapon Damage: " + str((stats.weapon_damage_multi - 1)*100) + '%'
	skill_dmg_label.text = "Skill Damage: " + str((stats.skill_damage - 1)*100) + '%'
	boost_label.text = "Boost Effect: " + str((stats.boost_multi - 1)*100) + '%'
	debuff_label.text = 'Debuff Resist: ' + str((1-(stats.debuff_multi))*100) + "%"

func update_active_effects() -> void:
	$"Active Effects/Label".text = str(stats.powerups)
