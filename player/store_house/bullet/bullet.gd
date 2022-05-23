extends KinematicBody2D

var direction : Vector2
export var speed := 200.0
export var damage := 1
export var spin := 5


func _ready():
	direction = direction.normalized()


func _process(delta):
	rotation_degrees += 5
	
	move_and_collide(direction * speed * delta)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(area):
	var collider = area.get_owner()
	if collider.is_in_group("enemy"):
		collider.damaged(damage)
		queue_free()


func lvl_up():
	damage = 3
	rotation = 20
