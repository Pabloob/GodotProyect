extends StaticBody2D

@export var numLlavesNecesarias: int = 0

@onready var colisionador = $CollisionShape2D
@onready var label = $Label

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		if body.llaves >= numLlavesNecesarias:
			label.text = "¡Puerta abierta!"
			await get_tree().create_timer(1).timeout
			queue_free()
		else:
			label.text = "Necesitas %d llaves" % numLlavesNecesarias
