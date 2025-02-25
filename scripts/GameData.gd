extends Node

var vidas: int = 3
var monedas: int = 0
var monedasTemp: int = 0
var nivel_actual: String = ""
var niveles: Array = [] 
var nivel_index: int = 0 
var volumen_musica: float = 100
var volumen_efectos: float = 100
var niveles_disponibles: Array = ["res://scenes/Niveles/1.tscn"]

const SAVE_PATH = "user://config.cfg" 

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

	config.save(SAVE_PATH)

func cargar_partida():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return

	vidas = config.get_value("game", "vidas", 3)
	monedas = config.get_value("game", "monedas", 0)
	nivel_actual = config.get_value("game", "nivel_actual", "")
	nivel_index = config.get_value("game", "nivel_index", 0)
	volumen_musica = config.get_value("game", "volumen_musica", 100)
	volumen_efectos = config.get_value("game", "volumen_efectos", 100)
	niveles_disponibles = config.get_value("game", "niveles_disponibles", ["res://scenes/Niveles/1.tscn"])

func resetear_partida():
	vidas = 3
	monedas = 0
	nivel_actual = ""
	nivel_index = 0
	niveles_disponibles = ["res://scenes/Niveles/1.tscn"]
	guardar_partida()
