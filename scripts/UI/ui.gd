extends CanvasLayer

# Referencias a los nodos de la UI
@onready var transicionOscurecer = $TransicionOscurecer  # Nodo que maneja la transición de pantalla
@onready var textoVidas = $Vidas/numVidas  # Texto que muestra la cantidad de vidas
@onready var textoMonedas = $Monedas/numMonedas  # Texto que muestra la cantidad de monedas
@onready var textoLlaves = $LLaves/numLLaves  # Texto que muestra la cantidad de llaves
@onready var menuFinJuego = $MenuFinJuego  # Menú de finalización de juego (victoria/derrota)
@onready var panelLlaves = $LLaves  # Panel que muestra las llaves en la UI

# Variables de transición de pantalla
var fade_speed = 2.0  # Velocidad del efecto de oscurecimiento
var target_alpha = 0.0  # Nivel de opacidad objetivo

# Número total de llaves necesarias para abrir una puerta
var numLlavesNecesarias = 0

func _ready():
	# Espera un frame antes de actualizar la UI para asegurarse de que GameData está cargado
	await get_tree().process_frame
	
	# Actualiza los valores iniciales de monedas y vidas según GameData
	actualizar_monedas(GameData.monedas)
	actualizar_vidas(GameData.vidas)

func _process(delta):
	# Aplica un efecto de transición ajustando la opacidad gradualmente
	transicionOscurecer.self_modulate.a = move_toward(transicionOscurecer.self_modulate.a, target_alpha, fade_speed * delta)

# Función para oscurecer la pantalla
func oscurecer():
	target_alpha = 0.0

# Función para aclarar la pantalla
func aclarar():
	target_alpha = 1.0

# Actualiza la cantidad de vidas en la UI
func actualizar_vidas(nuevas_vidas: int):
	textoVidas.text = str(max(nuevas_vidas, 0))  # Se asegura de que no muestre valores negativos

# Actualiza la cantidad de monedas en la UI
func actualizar_monedas(nuevas_monedas: int):
	textoMonedas.text = str(max(nuevas_monedas, 0))  # Se asegura de que no muestre valores negativos

# Actualiza la cantidad de llaves en la UI y muestra el panel si hay llaves necesarias
func actualizar_llaves(nuevas_llaves: int):
	panelLlaves.visible = true  # Asegura que el panel sea visible si hay llaves necesarias
	textoLlaves.text = str(max(nuevas_llaves, 0)) + "/" + str(numLlavesNecesarias)

# Muestra el menú de fin de juego con mensaje de victoria o derrota
func mostrarMensaje(muerto: bool):
	menuFinJuego.mostrar_ui(muerto)
