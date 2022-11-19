extends Control

var start_song = preload("res://assets/music/oomba/oomba_start.wav")
var loop_song = preload("res://assets/music/oomba/oomba_loop.wav")
var end_song = preload("res://assets/music/oomba/oomba_ent.wav")

onready var music: AudioStreamPlayer = $"%AudioStreamPlayer"



func _on_AudioStreamPlayer2D_finished() -> void:
	match music.stream:
		start_song:
			music.stream = loop_song
			music.play()
		loop_song:
			music.stream = loop_song
			music.play()
