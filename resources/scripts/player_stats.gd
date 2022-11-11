extends Resource

class_name PlayerStats

var hp : int# this is changed by the player's take_damage function
var mana : int

export(String) var nametag = "Player"
export(int) var max_hp = 100
export(int) var max_mana = 25
export(int) var base_damage = 5
export(int) var weapon_damage = 5
export(int) var speed = 8 # affects the order of turns
export(int) var defense = 5 # minus any damage by this
export(int) var defense_pierce = 3
export(String, 'Physical','Fire', 'Ice', 'Lightning') var weapon_damage_type
export(float) var physical_resist = 1.0
export(float) var fire_resist = 1.0
export(float) var ice_resist = 1.0
export(float) var lightning_resist = 1.0
export(float) var physical_damage = 1.0
export(float) var fire_damage = 1.0
export(float) var ice_damage = 1.0
export(float) var lightning_damage = 1.0
export(float) var weapon_damage_multi = 1.0
export(float) var skill_damage = 1.0
export(float) var boost_multi = 1.0
export(float) var debuff_multi = 1.0

var powerups:Dictionary

var goblins_killed = 0
var humans_killed = 0
var powerups_gained = 0
