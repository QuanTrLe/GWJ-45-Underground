extends Node2D

var seed_2_unlock = false
var seed_3_unlock = false


func lvl_canon_damage():
	get_tree().get_nodes_in_group("bullet")[0].lvl_up()


func lvl_canon_firerate():
	get_tree().get_nodes_in_group("store_house")[0].lvl_up_firerate()


func lvl_tool_harvest():
	get_tree().get_nodes_in_group("tool")[0].lvl_up()
