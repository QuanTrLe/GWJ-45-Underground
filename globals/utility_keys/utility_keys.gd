extends Node


func _unhandled_key_input(_event):
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	elif Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
