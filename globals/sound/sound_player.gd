extends AudioStreamPlayer


func _on_sound_player_finished():
	queue_free()
