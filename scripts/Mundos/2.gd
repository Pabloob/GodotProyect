extends TileMapLayer

var enZonaJefeFinal = false  # Indica si el jugador está en la zona del jefe final

@onready var ui = get_tree().get_first_node_in_group("ui")  # Referencia a la UI
@onready var fondo = get_tree().get_first_node_in_group("fondo")  # Referencia al fondo del nivel

func _on_zona_normal_body_entered(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return  # Ignora cualquier objeto que no sea el jugador

	match enZonaJefeFinal:
		true: _activar_modo_normal()  # Si estaba en la zona del jefe, vuelve a la normalidad
		false: ui.aclarar()  # Si ya estaba en la zona normal, solo aclara la UI

func _on_zona_final_body_entered(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return  # Evita que otros objetos activen la transición

	match enZonaJefeFinal:
		true: ui.aclarar()  # Si ya estaba en la zona del jefe, solo aclara la UI
		false: _activar_modo_jefe_final()  # Activa el modo del jefe si aún no está activo

func _activar_modo_normal():
	ui.oscurecer()  # Oscurece la UI para enfatizar el cambio
	fondo.activar_fondo_1()  # Activa el fondo normal del nivel
	Sonidos.detener_musica()  # Detiene la música actual
	Sonidos.reproducir_musica("musica_juego")  # Reproduce la música estándar del nivel
	enZonaJefeFinal = false  # Marca que ya no está en la zona del jefe

func _activar_modo_jefe_final():
	ui.oscurecer()  # Oscurece la UI para la transición al jefe final
	fondo.activar_fondo_2()  # Activa un fondo distinto para la zona del jefe
	Sonidos.detener_musica()  # Detiene la música actual
	Sonidos.reproducir_musica("musica_jefe_final")  # Activa la música de combate del jefe
	enZonaJefeFinal = true  # Marca que el jugador ha entrado en la zona del jefe
