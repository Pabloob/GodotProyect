extends CanvasLayer

@onready var transicionOscurecer = $TransicionOscurecer
@onready var textoVidas = $Vidas/numVidas
@onready var textoMonedas = $Monedas/numMonedas
@onready var menuFinJuego = $MenuFinJuego
@onready var panelMovil = $PanelMovil

var fade_speed = 2.0
var target_alpha = 0.0

func _ready():
	if is_mobile():
		panelMovil.visible = true
	else:
		panelMovil.visible = false

	actualizar_monedas(GameData.monedas)
	actualizar_vidas(GameData.vidas)

func _process(delta):
	transicionOscurecer.self_modulate.a = move_toward(transicionOscurecer.self_modulate.a, target_alpha, fade_speed * delta)

func fade_out():
	target_alpha = 0.0

func fade_in():
	target_alpha = 1.0

func actualizar_vidas(nuevas_vidas: int):
	textoVidas.text = str(max(nuevas_vidas, 0))

func actualizar_monedas(nuevas_monedas: int):
	textoMonedas.text = str(max(nuevas_monedas, 0))

func mostrarMensaje(muerto: bool):
	menuFinJuego.mostrar_ui(muerto)

func is_mobile() -> bool:
	var os_name = OS.get_name().to_lower()
	return os_name.contains("android") or os_name.contains("ios")

func simulate_input_action(action_name: String, pressed: bool):
	var event = InputEventAction.new()
	event.action = action_name  
	event.pressed = pressed     
	Input.parse_input_event(event)  

func _on_boton_ataque_pressed() -> void:
	simulate_input_action("atack", true)

func _on_boton_salto_pressed() -> void:
	simulate_input_action("move_up", true)

func _on_boton_pausa_pressed() -> void:
	simulate_input_action("pause", true)

func _on_boton_ataque_released() -> void:
	simulate_input_action("atack", false)

func _on_boton_salto_released() -> void:
	simulate_input_action("move_up", false)
