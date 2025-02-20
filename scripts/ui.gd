extends CanvasLayer

func _ready():
	# Conectar todas las monedas
	for coin_node in get_tree().get_nodes_in_group("moneda"):
		coin_node.coinCollected.connect(handle_coin_collected)

	actualizar_monedas(GameData.monedas)
	actualizar_vidas(GameData.vidas)

func handle_coin_collected():
	GameData.monedas += 1
	actualizar_monedas(GameData.monedas)

func actualizar_vidas(nuevas_vidas: int):
	$Vidas/numVidas.text = str(nuevas_vidas)

func actualizar_monedas(nuevas_monedas: int):
	$Monedas/numMonedas.text = str(nuevas_monedas)
