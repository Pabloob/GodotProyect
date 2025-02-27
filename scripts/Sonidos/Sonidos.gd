extends Node

@onready var sfx_player = AudioStreamPlayer.new()
@onready var music_player = AudioStreamPlayer.new()

@onready var sonidos = {
	"victoria": load("res://sounds/UI/Victoria.wav"),
	"derrota": load("res://sounds/UI/Derrota.wav"),
	
	"musica_menu": load("res://sounds/Musica/Menu.mp3"),
	"musica_juego": load("res://sounds/Musica/Juego.wav"),
	
	"boton_menu": load("res://sounds/UI/BotonMenu.wav"),
	"boton_nivel": load("res://sounds/UI/BotonNivel.wav")
}

func _ready():
	music_player.volume_db = GameData.volumen_musica
	sfx_player.volume_db = GameData.volumen_efectos
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(sfx_player)
	add_child(music_player)
	sfx_player.bus = "SFX"
	music_player.bus = "Music"
	
	reproducir_musica("musica_menu")

func reproducir_sfx(nombre: String):
	if sonidos.has(nombre):
		sfx_player.stream = sonidos[nombre]
		sfx_player.play()

func reproducir_musica(nombre: String):
	if sonidos.has(nombre) and music_player.stream != sonidos[nombre]:
		music_player.stream = sonidos[nombre]
		music_player.play()

func actualizarVolumenMusica():
	music_player.volume_db = GameData.volumen_musica

func actualizarVolumenSFX():
	sfx_player.volume_db = GameData.volumen_efectos

# Parar la música
func detener_musica():
	music_player.stream = null
	music_player.stop()
