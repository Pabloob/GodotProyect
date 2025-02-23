extends CanvasLayer

@onready var panel = $PanelOscurecer
@onready var textoVidas = $Vidas/numVidas
@onready var textoMonedas = $Monedas/numMonedas
@onready var menuHasGanado = $HasGanado
@onready var panelMovil = $PanelMovil

@onready var boton_salto = $PanelMovil/HBoxContainer/BotonSalto
@onready var boton_ataque = $PanelMovil/HBoxContainer/BotonAtaque
@onready var boton_pausa = $PanelMovil/HBoxContainer/BotonPausa

var fade_speed = 2.0
var target_alpha = 0.0
var es_movil: bool = false

func _ready():
	_detectar_plataforma()
	actualizar_monedas(GameData.monedas)
	actualizar_vidas(GameData.vidas)
	panelMovil.visible = es_movil

	if es_movil:
		boton_salto.pressed.connect(_on_boton_salto_pressed)
		boton_ataque.pressed.connect(_on_boton_ataque_pressed)

func _process(delta):
	panel.self_modulate.a = move_toward(panel.self_modulate.a, target_alpha, fade_speed * delta)

func fade_out():
	target_alpha = 0.0

func fade_in():
	target_alpha = 1.0 

func actualizar_vidas(nuevas_vidas: int):
	textoVidas.text = str(max(nuevas_vidas, 0))

func actualizar_monedas(nuevas_monedas: int):
	textoMonedas.text = str(max(nuevas_monedas, 0))

func mostrarMensajeHasGanado(muerto: bool):
	menuHasGanado.mostrar_ui(muerto)
	
func _detectar_plataforma():
	var plataforma = OS.get_name()
	es_movil = (plataforma == "Android" or plataforma == "iOS")

func _on_boton_salto_pressed():
	Input.action_press("move_up")

func _on_boton_ataque_pressed():
	Input.action_press("left_click")
	
func _on_boton_pausa_pressed() -> void:
	Input.action_press("pause")
