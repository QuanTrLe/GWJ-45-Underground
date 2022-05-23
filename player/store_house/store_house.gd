extends Node2D

export var max_hp := 10
var hp = max_hp

var can_shoot = true
export var reload_time := 0.35
export var bullet_scene: PackedScene


func _ready():
	$reload_time.wait_time = reload_time


func _process(_delta):
	#for shooting
	if Input.is_action_pressed("left_click") and can_shoot:
		shoot()
		can_shoot = false
		$reload_time.start()


func shoot():
	Sound.play_sound("shoot")
	var bullet = bullet_scene.instance()
	bullet.direction = get_global_mouse_position() - global_position
	
	$bullets.add_child(bullet)


func damaged(amount):
	hp -= amount
	if hp <= 0:
		destroyed()


func destroyed():
	get_tree().reload_current_scene()


func _on_reload_time_timeout():
	can_shoot = true


func lvl_up_firerate():
	reload_time = reload_time/5
