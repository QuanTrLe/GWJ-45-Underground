extends Node2D

enum states{USING, STORING}
var current_state = states.STORING

var harvest_plants = []

var store_location := Vector2()

var lvl = 1


func _ready():
	store_location = global_position
	
	$Sprite/sprite_1.visible = true 
	$Sprite/sprite_2.visible = false


func _process(_delta):
	match current_state:
		states.USING:
			using()
		states.STORING:
			storing()


func using():
	if Input.is_action_just_pressed("left_click"):
		harvest()
	global_position = get_global_mouse_position()


func storing():
	if global_position != store_location:
		global_position = store_location
	else:
		pass


func harvest():
	Sound.play_sound("harvest")
	for i in harvest_plants:
		i.harvested()
	if lvl == 2:
		Money_manager.money += 5


func lvl_up():
	lvl += 1
	$Sprite/sprite_1.visible = false
	$Sprite/sprite_2.visible = true


func switch_state():
	match current_state:
		states.USING:
			current_state = states.STORING
		states.STORING:
			current_state = states.USING


func _on_Area2D_area_entered(area):
	if area.get_parent().is_in_group("plant"):
		harvest_plants.append(area.get_parent())


func _on_Area2D_area_exited(area):
	if area.get_parent().is_in_group("plant"):
		harvest_plants.erase(area.get_parent())
