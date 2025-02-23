extends Node2D

@onready var mapa = $Mapa

func _ready():
	if GameData.nivel_actual != "":
		copiar_tilemap_y_nodos(GameData.nivel_actual)

func copiar_tilemap_y_nodos(mapa_ruta: String):
	var mapa_escena = load(mapa_ruta).instantiate()
	var tilemap_fuente = mapa_escena
	tilemap_fuente.position = mapa.position
	mapa.clear()
	add_child(tilemap_fuente)
