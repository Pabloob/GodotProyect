extends CanvasLayer

@onready var panel = $MIERDA  # Referencia al Panel

var fade_speed = 1.0  # Velocidad de transición
var target_alpha = 0.0  # Objetivo de alpha (0 = transparente, 1 = opaco)

func _ready() -> void:

	actualizar_monedas(GameData.monedas)
	actualizar_vidas(GameData.vidas)

# Proceso que actualiza la opacidad gradualmente
func _process(delta):
	# Actualiza la opacidad hacia target_alpha
	panel.self_modulate.a = move_toward(panel.self_modulate.a, target_alpha, fade_speed * delta)

# Función para oscurecer el panel
func fade_out():
	# Solo ajustamos el objetivo de alpha para oscurecer (transparente)
	target_alpha = 0.0  # Esto hará que el panel se vuelva completamente transparente
	print("Oscurecer")

# Función para aclarar el panel
func fade_in():
	# Solo ajustamos el objetivo de alpha para aclarar (opaco)
	target_alpha = 1.0  # Esto hará que el panel vuelva completamente opaco
	print("Aclarar")

func actualizar_vidas(nuevas_vidas: int):
	if nuevas_vidas <= 0:
		nuevas_vidas = 0
	$Vidas/numVidas.text = str(nuevas_vidas)

func actualizar_monedas(nuevas_monedas: int):
	if nuevas_monedas <= 0:
		nuevas_monedas = 0
	$Monedas/numMonedas.text = str(nuevas_monedas)
