extends CanvasLayer


func _ready():
	get_tree().paused = true
	$start.visible = true
	$win.visible = false


func _on_start_button_pressed():
	get_tree().paused = false
	$start.visible = false


func win():
	get_tree().paused = true
	$win.visible = true
