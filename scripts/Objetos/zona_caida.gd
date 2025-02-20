extends Area2D

func _on_body_entered(body):
	if body.has_method("perder_vida"):
		body.perder_vida()
