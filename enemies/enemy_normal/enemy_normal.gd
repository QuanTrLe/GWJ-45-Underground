extends KinematicBody2D

enum states{PLANT,HOUSE}
var current_state = states.PLANT

onready var store_house = get_tree().get_nodes_in_group("store_house")[0]

export var hp = 1
export var damage = 1

var target

export var max_speed = 100


func _ready():
	$animation_player.play("dig")
	find_target()


func find_target():
	var available_targets = get_tree().get_nodes_in_group("plant")
	if available_targets.size() == 0:
		target = store_house
		return
	var distance_to_target = global_position.distance_to(available_targets[0].global_position)
			
	for i in available_targets:
		var distance = global_position.distance_to(i.global_position)
				
		if distance <= distance_to_target:
			distance_to_target = distance
			target = i


func _process(delta):
	if is_instance_valid(target):
		var dir = global_position.direction_to(target.global_position)
		move_and_collide(dir * max_speed * delta)
		
		look_at(target.global_position)
		rotation_degrees += 90
	
	else:
		find_target()


func damaged(amount):
	hp -= amount
	if hp <= 0:
		destroyed()


func destroyed():
	Sound.play_sound("normal_enemy_death")
	queue_free()


func _on_hitbox_area_entered(area):
	var target = area.get_parent()
	
	if target.is_in_group("plant"):
		target.queue_free()
	elif target.is_in_group("store_house"):
		target.damaged(damage)
		queue_free()
