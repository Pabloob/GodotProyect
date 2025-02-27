extends CanvasLayer

@onready var transicionOscurecer = $TransicionOscurecer
@onready var textoVidas = $Vidas/numVidas
@onready var textoMonedas = $Monedas/numMonedas
@onready var textoLlaves = $LLaves/numLLaves
@onready var menuFinJuego = $MenuFinJuego
@onready var panelLlaves = $LLaves

var fade_speed = 2.0
var target_alpha = 0.0

var numLlavesNecesarias = 0

func _ready():
	await get_tree().process_frame
	actualizar_monedas(GameData.monedas)
	actualizar_vidas(GameData.vidas)
	
func _process(delta):
	transicionOscurecer.self_modulate.a = move_toward(transicionOscurecer.self_modulate.a, target_alpha, fade_speed * delta)

func oscurecer():
	target_alpha = 0.0

func aclarar():
	target_alpha = 1.0

func actualizar_vidas(nuevas_vidas: int):
	textoVidas.text = str(max(nuevas_vidas, 0))

func actualizar_monedas(nuevas_monedas: int):
	textoMonedas.text = str(max(nuevas_monedas, 0))

func actualizar_llaves(nuevas_llaves: int):
	panelLlaves.visible = true
	textoLlaves.text = str(max(nuevas_llaves, 0)) + "/" + str(numLlavesNecesarias)

func mostrarMensaje(muerto: bool):
	menuFinJuego.mostrar_ui(muerto)
