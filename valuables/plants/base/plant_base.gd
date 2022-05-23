extends Node2D

var can_place = true
var collision = 0
onready var tilemap = get_tree().get_nodes_in_group("room_tilemap")[1]
var tile_offset = Vector2(16,24)
export var tile_id = 21

var value = 0
export var value_increase := 2

var growth = 0
var max_growth := 3
export var growth_period := 6

enum states{PLACING, PLACED}
var current_state = states.PLACING


func _ready(): #setup default from export vars
	$growth_timer.wait_time = growth_period
	
	for i in $sprite.get_children():
		i.visible = false
	$sprite.get_children()[growth].visible = true


func _process(_delta):
	#match state
	match current_state:
		states.PLACING:
			placing()
		states.PLACED:
			pass


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
		$growth_timer.start()
		current_state = states.PLACED
	
	elif Input.is_action_just_pressed("right_click"):
		queue_free()


func increase_plant_value():
	#modify stat
	growth += 1
	value += value_increase
	
	#modify sprite
	for i in $sprite.get_children():
		i.visible = false
	$sprite.get_children()[growth].visible = true


func harvested():
	Money_manager.add(value)
	queue_free()


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


func _on_growth_timer_timeout(): #increase value and change plant
	if growth >= max_growth:
		$growth_timer.stop()
		return
	increase_plant_value()
	$growth_timer.start()


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
