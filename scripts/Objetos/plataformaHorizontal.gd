extends CharacterBody2D

var speed = 50
var direction = -1

func _physics_process(delta):
	var velocity = Vector2(speed * direction, 0)
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider and !collider.is_in_group("personajes"):
			direction *= -1
