# 🦖 DinoJump - Juego en Godot 4.3

**DinoJump** es un juego de plataformas desarrollado en **Godot 4.3** utilizando **GDScript**. Inspirado en el clásico juego del dinosaurio de Google Chrome, este proyecto introduce mecánicas mejoradas de salto, obstáculos y animaciones fluidas.

---

## 🎮 Características Principales

- **Movimiento fluido** con física optimizada.
- **Salto con gravedad dinámica** para mejorar la jugabilidad.
- **Generación de obstáculos aleatorios** para mayor rejugabilidad.
- **Sistema de puntuación** basado en la distancia recorrida.
- **Modo noche y día** con cambio de colores dinámico.
- **Sprites y animaciones** creados con **Aseprite**.

---

## 🚀 Tecnologías Utilizadas

- **Godot 4.3** → Motor principal del juego.
- **GDScript** → Lenguaje de scripting para lógica del juego.
- **Tilemaps** → Para la generación del entorno.
- **Node2D y CharacterBody2D** → Base de los personajes y objetos.
- **Aseprite** → Creación de sprites y animaciones.

---

## 📂 Estructura del Proyecto

```
dinojump/
│── assets/          # Sprites y animaciones
│── scenes/          # Escenas principales del juego
│   ├── Main.tscn    # Escena principal
│   ├── Player.tscn  # Escena del jugador
│   ├── Obstacles.tscn  # Escena de obstáculos
│── scripts/         # Código en GDScript
│   ├── player.gd    # Script del jugador
│   ├── obstacles.gd # Script de generación de obstáculos
│   ├── game.gd      # Lógica principal del juego
│── sounds/          # Efectos de sonido y música
│── icon.png         # Icono del juego
│── project.godot    # Configuración del proyecto
└── README.md        # Documentación
```

---

## 🕹️ Mecánicas del Juego

### **1️⃣ Movimiento del Jugador**
- Controlado por un `CharacterBody2D`.
- Gravedad ajustable para saltos más realistas.
- Sistema de doble salto.

```gdscript
extends CharacterBody2D

const GRAVITY = 980.0
const JUMP_FORCE = -400.0

func _physics_process(delta):
    velocity.y += GRAVITY * delta
    
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_FORCE
    
    move_and_slide()
```

---

### **2️⃣ Generación de Obstáculos**
- Se crean aleatoriamente con un `Timer`.
- Velocidad de desplazamiento ajustable.
- Se destruyen fuera de la pantalla para optimizar rendimiento.

```gdscript
extends Node2D

var obstacle_scene = preload("res://scenes/Obstacles.tscn")

func _on_timer_timeout():
    var obstacle = obstacle_scene.instantiate()
    obstacle.position = Vector2(800, 500)
    add_child(obstacle)
```

---

### **3️⃣ Sistema de Puntuación**
- Basado en la distancia recorrida.
- Guardado en `UserData` para almacenar récords.

```gdscript
var score = 0
func _process(delta):
    score += 1
    $ScoreLabel.text = "Puntuación: " + str(score)
```

---

## 📱 Responsividad y Adaptación

- **Modo ventana y pantalla completa**.
- **Escalado dinámico de sprites** basado en la resolución.
- **Soporte para teclado y táctil** en dispositivos móviles.

---

## 🔧 Instalación y Ejecución

1️⃣ Clona este repositorio:
```sh
git clone https://github.com/Pabloob/DinoJump.git
```

2️⃣ Abre el proyecto en **Godot 4.3**.

3️⃣ Ejecuta la escena principal (`Main.tscn`).

---

## 📢 Despliegue

Si deseas exportar el juego:
1. Ve a `Proyecto > Exportar` en Godot.
2. Selecciona la plataforma (Windows, HTML5, Android, etc.).
3. Configura los ajustes y exporta.

El juego puede jugarse en navegador si se compila para **HTML5/Web**.

---

## 📌 Autor

**Pablo Orbea Benitez** – [GitHub](https://github.com/Pabloob) | [LinkedIn](https://www.linkedin.com/in/pabloob5)

🎮 ¡Disfruta jugando DinoJump! 🚀
