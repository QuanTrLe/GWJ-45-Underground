extends Node2D

var can_place = true

var collision = -1
onready var background_tilemap = get_tree().get_nodes_in_group("room_tilemap")[0]
onready var tilemap = get_tree().get_nodes_in_group("room_tilemap")[0]
export var tile_id = 22

enum states{PLACING, PLACED}
var current_state = states.PLACING


func _process(_delta):
	match current_state:
		states.PLACING:
			placing()
		states.PLACED:
			pass


func placing():
	#Sets plant at middle of current tile
	var mouse_position = get_global_mouse_position()
	var tile = tilemap.world_to_map(tilemap.to_local(mouse_position))
	var tile_position = tilemap.to_global(tilemap.map_to_world(tile))
	global_position = tile_position
	
	#check if first tile is available or not
	if background_tilemap.get_cellv(tile) != tile_id:
		can_place = false
	else:
		can_place = true
	
	#shows can be placed or not
	if collision != 0 or !can_place:
		modulate = Color.red
	else:
		modulate = Color.white
	
	#places when clicked
	if Input.is_action_just_pressed("left_click"):
		if !can_place or collision != 0:
			return
		
		set_process(false)
		
	elif Input.is_action_just_pressed("right_click"):
		queue_free()


func _on_collision_check_body_entered(body):
	if body is TileMap:
		if body.name == "background_room_tilemap":
			return
		elif body.name == "nature_tilemap":
			return
		collision += 1
		print(collision)


func _on_collision_check_body_exited(body):
	if body is TileMap:
		if body.name == "background_room_tilemap":
			return
		elif body.name == "nature_tilemap":
			return
		collision -= 1
		print(collision)
