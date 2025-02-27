extends Node2D

# Referencia al nodo del mapa en la escena
@onready var mapa = $Mapa

func _ready():
	# Reproduce la música del juego
	Sonidos.reproducir_musica("musica_juego")
	
	# Reinicia el estado del nivel (monedas, llaves, etc.)

	# Si hay un nivel guardado, lo carga
	if GameData.nivel_actual != "":
		copiar_tilemap_y_nodos(GameData.nivel_actual)

# Carga y copia los elementos de un mapa guardado
func copiar_tilemap_y_nodos(mapa_ruta: String):
	# Carga la escena del mapa desde la ruta proporcionada
	var mapa_escena = load(mapa_ruta).instantiate()

	# Asigna la posición del nuevo mapa a la del mapa original
	mapa_escena.position = mapa.position
	
	# Limpia el mapa actual antes de agregar el nuevo
	mapa.clear()
	
	# Asegura que el nuevo mapa esté detrás de otros elementos
	mapa_escena.z_index = -1
	
	# Agrega el nuevo mapa a la escena
	add_child(mapa_escena)
