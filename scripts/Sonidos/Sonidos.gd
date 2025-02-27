extends Node

# Creación de reproductores de audio para música y efectos de sonido
@onready var sfx_player = AudioStreamPlayer.new()
@onready var music_player = AudioStreamPlayer.new()

# Diccionario de sonidos precargados
@onready var sonidos = {
	"victoria": load("res://sounds/UI/Victoria.wav"),
	"derrota": load("res://sounds/UI/Derrota.wav"),
	
	"musica_menu": load("res://sounds/Musica/Menu.mp3"),
	"musica_juego": load("res://sounds/Musica/Juego.mp3"),
	"musica_jefe_final": load("res://sounds/Musica/JefeFinal.mp3"),
	
	"boton_menu": load("res://sounds/UI/BotonMenu.wav"),
	"boton_nivel": load("res://sounds/UI/BotonNivel.wav")
}

func _ready():
	# Establece los volúmenes iniciales desde GameData
	music_player.volume_db = GameData.volumen_musica
	sfx_player.volume_db = GameData.volumen_efectos
	
	# Permite que el nodo procese siempre (incluso si no está en pantalla)
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Añade los reproductores de audio como hijos del nodo
	add_child(sfx_player)
	add_child(music_player)

	# Asigna cada reproductor a su respectivo bus de audio
	sfx_player.bus = "SFX"
	music_player.bus = "Music"

# Reproduce un efecto de sonido sin interrumpir otros que estén sonando
func reproducir_sfx(nombre: String):
	if sonidos.has(nombre):
		# Crea un nuevo AudioStreamPlayer para cada efecto de sonido
		var sfx = AudioStreamPlayer.new()
		sfx.bus = "SFX"
		sfx.volume_db = GameData.volumen_efectos
		sfx.stream = sonidos[nombre]
		
		# Añade el nodo a la escena y lo reproduce
		add_child(sfx)
		sfx.play()
		
		# Elimina el nodo cuando el sonido termina para liberar memoria
		sfx.finished.connect(func(): sfx.queue_free())

# Reproduce una música solo si es diferente a la que ya está sonando
func reproducir_musica(nombre: String):
	if sonidos.has(nombre) and music_player.stream != sonidos[nombre]:
		music_player.volume_db = GameData.volumen_musica
		music_player.stream = sonidos[nombre]
		music_player.play()

# Actualiza el volumen de la música con el valor guardado en GameData
func actualizarVolumenMusica():
	music_player.volume_db = GameData.volumen_musica

# Actualiza el volumen de los efectos de sonido con el valor guardado en GameData
func actualizarVolumenSFX():
	sfx_player.volume_db = GameData.volumen_efectos

# Detiene la música actual y libera el stream
func detener_musica():
	music_player.stop()
	music_player.stream = null
