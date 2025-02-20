extends Area2D

signal coinCollected

func _on_body_entered(body):
	if body.name == "personaje":
		emit_signal("coinCollected")
		queue_free()
