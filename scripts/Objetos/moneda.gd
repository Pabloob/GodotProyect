extends Area2D

var monedas=0

func _ready():
	$Sprite2D.play("coin")
	monedas=GameData.monedas
func _on_body_entered(body):
	if body.is_in_group("jugador"):
		GameData.monedasTemp += 1
		monedas+=1
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.actualizar_monedas(monedas)
		queue_free()
