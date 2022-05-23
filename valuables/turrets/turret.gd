extends Node2D

var can_place = true
var collision = 0
onready var tilemap = get_tree().get_nodes_in_group("room_tilemap")[1]
var tile_offset = Vector2(16,24)
export var tile_id = 21

enum states{PLACING, PLACED}
var current_state = states.PLACING

var available_targets = []
var target
var can_shoot = true

export var bullet_scene: PackedScene
export var reload_time := 0.6


func _ready():
	$reload_time.wait_time = reload_time


func _process(_delta):
	#match state
	match current_state:
		states.PLACING:
			placing()
		states.PLACED:
			placed()


func placing():
	#changes locatio based on mouse and grid
	var mouse_position = get_global_mouse_position()
	var tile = tilemap.world_to_map(tilemap.to_local(mouse_position))
	var tile_position = tilemap.to_global(tilemap.map_to_world(tile))
	global_position = tile_position + tile_offset
	
	#changes color to indicate can place
	if !can_place:
		modulate = Color.red
	else:
		modulate = Color.white
	
	#place plant if space is available
	if Input.is_action_just_pressed("left_click"):
		if !can_place or collision != 0:
			return
		
		#set up plant
		$hitbox.monitoring = false
		current_state = states.PLACED
	
	elif Input.is_action_just_pressed("right_click"):
		queue_free()


func placed():
	if is_instance_valid(target):
		if can_shoot:
			
			var bullet = bullet_scene.instance()
			bullet.direction = target.global_position - global_position
			bullet.speed = bullet.speed * 1.75
			
			$bullets.add_child(bullet)
			can_shoot = false
			$reload_time.start()
	else:
		find_target()


func find_target():
	if available_targets.size() == 0:
		return
	var distance_to_target = global_position.distance_to(available_targets[0].global_position)
			
	for i in available_targets:
		var distance = global_position.distance_to(i.global_position)
				
		if distance <= distance_to_target:
			distance_to_target = distance
			target = i


func determine_tile(map):
	var mouse_position = get_global_mouse_position()
	var tile = map.world_to_map(map.to_local(mouse_position))
	
	if map.get_cellv(tile) != tile_id:
		can_place = false
	else:
		can_place = true


func _on_hitbox_area_entered(area):
	if area.get_parent().is_in_group("valuables"):
		collision += 1


func _on_hitbox_area_exited(area):
	if area.get_parent().is_in_group("valuables"):
		collision -= 1


func _on_hitbox_body_entered(body):
	if body is TileMap:
		if body.name == "background_room_tilemap":
			return
		elif body.name == "nature_tilemap":
			return
		determine_tile(body)


func _on_hitbox_body_exited(body):
	if body is TileMap:
		if body.name == "background_room_tilemap":
			return
		elif body.name == "nature_tilemap":
			return
		determine_tile(body)


func _on_reload_time_timeout():
	can_shoot = true


func _on_detection_area_entered(area):
	var object = area.get_parent()
	if object.is_in_group("enemy"):
		available_targets.append(object)


func _on_detection_area_exited(area):
	var object = area.get_parent()
	if object.is_in_group("enemy"):
		available_targets.erase(object)
