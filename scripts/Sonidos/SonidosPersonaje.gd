extends AudioStreamPlayer

# Carga de efectos de sonido del personaje
var caminar = load("res://sounds/Personaje/Caminar.wav")
var pegar = load("res://sounds/Personaje/Pegar.wav")
var saltar = load("res://sounds/Personaje/Saltar.wav")

func _ready():
	# Establece el volumen del AudioStreamPlayer según la configuración guardada en GameData
	volume_db = GameData.volumen_efectos

	# Asegura que el nodo siempre procese eventos, incluso si no está en pantalla
	process_mode = Node.PROCESS_MODE_ALWAYS

# Reproduce el sonido de caminar si no hay otro sonido en reproducción
func play_caminar():
	if not playing:  # Evita que el sonido se reproduzca en bucle si ya está sonando
		stream = caminar
		play()

# Reproduce el sonido de un ataque
func play_pegar():
	stream = pegar
	play()

# Reproduce el sonido de un salto
func play_saltar():
	stream = saltar
	play()

# Actualiza el volumen de los efectos de sonido según GameData
func actualizarVolumen():
	volume_db = GameData.volumen_efectos
