extends Control

export var room_scene: PackedScene
export var turret_scene: PackedScene

onready var structure_manager = get_tree().get_nodes_in_group("valuables")[0]
onready var store_house = get_tree().get_nodes_in_group("store_house")[0]


func check_money(amount):
	if Money_manager.money < amount:
		Sound.play_sound("buy_fail")
		return false
	Money_manager.money -= amount
	return true


func _on_room_button_pressed():
	if !room_scene:
		return
	if !check_money(130):
		return
	var room = room_scene.instance()
	structure_manager.get_node("rooms").add_child(room)
	visible = false


func _on_seed_2_button_pressed():
	if !check_money(35):
		return
	LvManager.seed_2_unlock = true
	$scroll_container/grid_container/placeable_objects/seed_2.queue_free()
	visible = false


func _on_seed_3_button_pressed():
	if !check_money(35):
		return
	LvManager.seed_3_unlock = true
	$scroll_container/grid_container/placeable_objects/seed_3.queue_free()
	visible = false


func _on_tool_2_button_pressed():
	if !check_money(70):
		return
	LvManager.lvl_tool_harvest()
	$scroll_container/grid_container/upgrades/tool_2.queue_free()
	visible = false


func _on_canon_damage_button_pressed():
	if !check_money(110):
		return
	LvManager.lvl_canon_damage()
	$scroll_container/grid_container/upgrades/canon_damage.queue_free()
	visible = false


func _on_canon_firerate_button_pressed():
	if !check_money(110):
		return
	LvManager.lvl_canon_firerate()
	$scroll_container/grid_container/upgrades/canon_firerate.queue_free()
	visible = false


func _on_heal_button_pressed():
	if !check_money(100):
		return
	store_house.hp = store_house.max_hp
	visible = false


func _on_turret_button_pressed():
	if !turret_scene:
		return
	if !check_money(50):
		return
	var turret = turret_scene.instance()
	structure_manager.get_node("turrets").add_child(turret)
	visible = false
