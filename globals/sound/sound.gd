extends Node2D

export var sound_player_scene: PackedScene

var sounds = {
	"buy_fail": "res://assets/sounds/buy_not_enough.wav",
	"harvest": "res://assets/sounds/crop.wav",
	"elite_enemy_death": "res://assets/sounds/elite_enemy_death.wav",
	"normal_enemy_death": "res://assets/sounds/normal_enemy_death.wav",
	"shoot": "res://assets/sounds/turret_shooting.wav",
	"background_1": "res://assets/sounds/SC-5588.wav",
	"background_2": "res://assets/sounds/The-Story-Thus-Far....wav"
}

var background_list = ["background_1", "background_2"]
var current_background = 0


func _ready():
	$background_audio.stream = load(sounds[background_list[current_background]])
	$background_audio.play()


func play_sound(name):
	var sound_player = sound_player_scene.instance()
	sound_player.stream = load(sounds[name])
	add_child(sound_player)
	sound_player.play()


func _on_AudioStreamPlayer_finished():
	if current_background == 0:
		current_background = 1
	else:
		current_background = 0
	$background_audio.stream = load(sounds[background_list[current_background]])
	$background_audio.play()
