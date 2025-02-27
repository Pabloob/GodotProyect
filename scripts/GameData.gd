extends Node

# Ruta donde se guardará la configuración del juego
const ruta_config = "user://config.cfg"

# Variables que almacenan el estado del juego
var vidas: int = 3  # Número de vidas del jugador
var monedas: int = 0  # Monedas recolectadas
var nivel_actual: String = ""  # Nombre del nivel actual
var nivel_index: int = 0  # Índice del nivel actual en la lista de niveles
var niveles: Array = []  # Lista de niveles disponibles
var volumen_musica: float = 0  # Volumen de la música
var volumen_efectos: float = 0  # Volumen de los efectos de sonido
var niveles_disponibles: Array = []  # Niveles desbloqueados por el jugador

# Notificación cuando la ventana del juego se cierra
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		guardar_partida()  # Guarda la partida al cerrar el juego

# Guarda el estado actual del juego en un archivo de configuración
func guardar_partida():
	var config = ConfigFile.new()
	config.set_value("game", "vidas", vidas)
	config.set_value("game", "monedas", monedas)
	config.set_value("game", "nivel_actual", nivel_actual)
	config.set_value("game", "nivel_index", nivel_index)
	config.set_value("game", "volumen_musica", volumen_musica)
	config.set_value("game", "volumen_efectos", volumen_efectos)
	config.set_value("game", "niveles_disponibles", niveles_disponibles)
	config.save(ruta_config)  # Guarda los datos en la ruta definida

# Carga el estado del juego desde el archivo de configuración
func cargar_partida():
	var config = ConfigFile.new()
	if config.load(ruta_config) == OK:  # Si el archivo existe y se carga correctamente
		vidas = config.get_value("game", "vidas", 3)  # Si no hay valor, usa el predeterminado
		monedas = config.get_value("game", "monedas", 0)
		nivel_actual = config.get_value("game", "nivel_actual", "")
		nivel_index = config.get_value("game", "nivel_index", 0)
		volumen_musica = config.get_value("game", "volumen_musica",0)
		volumen_efectos = config.get_value("game", "volumen_efectos",0)
		niveles_disponibles = config.get_value("game", "niveles_disponibles", [])

# Reinicia el estado del juego a los valores iniciales
func resetear_juego():
	vidas = 3
	monedas = 0
	nivel_actual = ""
	nivel_index = 0
	niveles_disponibles = []
	guardar_partida()  # Guarda el estado reiniciado

# Restablece solo las vidas del jugador sin afectar otros datos
func resetear_nivel():
	vidas = 3
