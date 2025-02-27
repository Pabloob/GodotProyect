extends Area2D

func _ready():
	$Sprite2D.play("coin")
	
func _on_body_entered(body):
	if body.is_in_group("jugador"):
		body.monedas_recogidas_nivel+=1
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.actualizar_monedas(body.monedas_recogidas_nivel)
		queue_free()
