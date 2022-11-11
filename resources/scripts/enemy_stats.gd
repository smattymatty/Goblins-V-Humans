class_name EnemyStats

extends Resource

export(String) var nametag
export var base_hp = 100
export var base_damage = 10
export var base_speed = 10
export var base_defense = 5
export var base_pierce = 2
export(String, 'Physical','Fire', 'Ice', 'Lightning') var damage_type
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
