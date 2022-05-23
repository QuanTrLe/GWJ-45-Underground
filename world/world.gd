extends Node2D

onready var store_house = get_tree().get_nodes_in_group("store_house")[0]
onready var seed_reference_rect =  $control/grid_container/seed_reference_rect
var seed_sprite_offset = Vector2(-12, -20)

export var seed_1_scene: PackedScene
export var seed_2_scene: PackedScene
export var seed_3_scene: PackedScene
var selected_seed_scene


func _ready():
	randomize()
	selected_seed_scene = seed_1_scene
	
	seed_reference_rect.rect_position = $control/grid_container/seed_1.position + seed_sprite_offset
	$CanvasLayer/shop_UI.visible = false


func _process(_delta):
	if Money_manager.money >= 800:
		$menus.win()
	
	if LvManager.seed_2_unlock:
		$control/grid_container/seed_2.modulate = Color.white
	if LvManager.seed_3_unlock:
		$control/grid_container/seed_3.modulate = Color.white


func _input(event):
	$control/money_label.text = "Money: " + str(Money_manager.money)
	$control/hp_label.text = "HP: " + str(store_house.hp)
	
	seed_selection()
	if Input.is_action_just_pressed("place_seed"):
		place_seed()
	
	if Input.is_action_just_pressed("tool"):
		$player/scythe.switch_state()
	
	if Input.is_action_just_pressed("shop"):
		$CanvasLayer/shop_UI.visible = !$CanvasLayer/shop_UI.visible


func seed_selection():
	if Input.is_action_just_pressed("choose_1"):
		seed_reference_rect.rect_position = $control/grid_container/seed_1.position + seed_sprite_offset
		selected_seed_scene = seed_1_scene
	elif Input.is_action_just_pressed("choose_2") and LvManager.seed_2_unlock:
		seed_reference_rect.rect_position = $control/grid_container/seed_2.position + seed_sprite_offset
		selected_seed_scene = seed_2_scene
	elif Input.is_action_just_pressed("choose_3") and LvManager.seed_3_unlock:
		seed_reference_rect.rect_position = $control/grid_container/seed_3.position + seed_sprite_offset
		selected_seed_scene = seed_3_scene


func place_seed():
	if !selected_seed_scene:
		return
	var selected_seed = selected_seed_scene.instance()
	$valuables/plants.add_child(selected_seed)
