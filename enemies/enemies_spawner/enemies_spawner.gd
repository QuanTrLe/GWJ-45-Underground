extends Node2D

export var normal_enemy_scene: PackedScene
export var elite_enemy_scene: PackedScene

var difficulty = 1

var spawn_time := 20.0
export var spawn_time_minimum := 20.0
export var spawn_time_maximum := 30.0

onready var spawn_position = $spawn_position

var x_spawn_minimum = -300
var x_spawn_maximum = 300

var normal_enemy_amount = 1
var elite_enemy_amount = 0


func _ready():
	randomize()
	set_spawn_time_random()


func set_spawn_time_random():
	spawn_time = rand_range(spawn_time_minimum, spawn_time_maximum)
	$difficulty_scale.start(spawn_time)


func spawn_enemies():
	#spawns normal enemies
	for i in range(1, normal_enemy_amount + 1):
		spawn_position.global_position.x = rand_range(x_spawn_minimum, x_spawn_maximum)
		var normal_enemy = normal_enemy_scene.instance()
		normal_enemy.global_position = spawn_position.global_position
		$enemies_normal.add_child(normal_enemy)
	
	#spawns elite enemies
	for i in range(1, elite_enemy_amount + 1):
		spawn_position.global_position.x = rand_range(x_spawn_minimum, x_spawn_maximum)
		var elite_enemy = elite_enemy_scene.instance()
		elite_enemy.global_position = spawn_position.global_position
		$enemies_normal.add_child(elite_enemy)


func increase_difficulty():
	difficulty += 1
	
	normal_enemy_amount += int(difficulty/2)
	if difficulty % 2 == 0:
		elite_enemy_amount += 1


func _on_difficulty_scale_timeout():
	spawn_enemies()
	increase_difficulty()
	set_spawn_time_random()
