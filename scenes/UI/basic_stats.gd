extends Control

onready var update_timer: Timer = $"%update_timer"
onready var player = Global.player
onready var hp_label: Label = $"%hp_label"
onready var mp_label: Label = $"%mp_label"
onready var spd_label: Label = $"%spd_label"
onready var hp_progress: TextureProgress = $"%hp_progress"
onready var mp_progress: TextureProgress = $"%mp_progress"
onready var dmg_label: Label = $"%dmg_label"
onready var def_label: Label = $"%def_label"
onready var turn_label: Label = $"%turn_label"

func _ready() -> void:
	update_stats()
	update_timer.connect("timeout",self,'update_stats')

func update_stats() -> void:
	player = Global.player
	hp_label.text = 'HP: '+ str(player.stats.hp) +'/'+ str(player.stats.max_hp)
	hp_progress.value = ((player.stats.hp/player.stats.max_hp) * 100)
	print(hp_progress.value, ' ', player.stats.hp, ' ', player.stats.max_hp, '    ', ((player.stats.hp/player.stats.max_hp) * 100))
	mp_label.text = 'MP: '+ str(player.stats.mana) +'/'+ str(player.stats.max_mana)
	mp_progress.value = (player.stats.mana/player.stats.max_mana) * 100
	dmg_label.text = 'DMG: ' +str(player.stats.base_damage+player.stats.weapon_damage)
	def_label.text = 'DEF: ' +str(player.stats.defense)
	spd_label.text = 'SPD: ' +str(player.stats.speed)
	turn_label.text = str(Global.top_3_speeds)
	
