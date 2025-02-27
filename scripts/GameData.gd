extends Node

const ruta_config = "user://config.cfg"

var vidas: int = 3
var monedas: int = 0
var nivel_actual: String = ""
var nivel_index: int = 0
var niveles: Array = []
var volumen_musica: float = 0
var volumen_efectos: float = 0
var niveles_disponibles: Array = []

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		guardar_partida()
func guardar_partida():
	var config = ConfigFile.new()
	config.set_value("game", "vidas", vidas)
	config.set_value("game", "monedas", monedas)
	config.set_value("game", "nivel_actual", nivel_actual)
	config.set_value("game", "nivel_index", nivel_index)
	config.set_value("game", "volumen_musica", volumen_musica)
	config.set_value("game", "volumen_efectos", volumen_efectos)
	config.set_value("game", "niveles_disponibles", niveles_disponibles)
	config.save(ruta_config)
func cargar_partida():
	var config = ConfigFile.new()
	if config.load(ruta_config) == OK:
		vidas = config.get_value("game", "vidas")
		monedas = config.get_value("game", "monedas", 0)
		nivel_actual = config.get_value("game", "nivel_actual", "")
		nivel_index = config.get_value("game", "nivel_index", 0)
		volumen_musica = config.get_value("game", "volumen_musica", 0)
		volumen_efectos = config.get_value("game", "volumen_efectos", 0)
		niveles_disponibles = config.get_value("game", "niveles_disponibles", [])
func resetear_juego():
	vidas = 3
	monedas = 0
	nivel_actual = ""
	nivel_index = 0
	niveles_disponibles = []
	guardar_partida()
func resetear_nivel():
	vidas=3
