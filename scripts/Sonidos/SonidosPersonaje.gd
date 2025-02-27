extends AudioStreamPlayer

var caminar = load("res://sounds/Personaje/Caminar.wav")
var pegar = load("res://sounds/Personaje/Pegar.wav")
var saltar = load("res://sounds/Personaje/Saltar.wav")
	

func _ready():
	volume_db = GameData.volumen_efectos
	process_mode = Node.PROCESS_MODE_ALWAYS
	
func play_caminar():
	if not playing:
		stream = caminar
		play()
		
func play_pegar():
		stream = pegar
		play()
		
func play_saltar():
		stream = saltar
		play()
		
func actualizarVolumen():
	volume_db = GameData.volumen_efectos
