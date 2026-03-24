extends Area2D

# 1. AÑADE ESTA LÍNEA AQUÍ ARRIBA
signal hit

@export var speed = 400 
var screen_size 

func _ready():
	screen_size = get_viewport_rect().size
	# 2. AÑADE ESTO PARA QUE EL JUGADOR ESTÉ OCULTO AL EMPEZAR
	hide()

func _process(delta):
	var velocity = Vector2.ZERO 
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play() 
	else:
		$AnimatedSprite2D.stop() 

	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# 3. AÑADE ESTA FUNCIÓN PARA CUANDO ALGO TOCA AL JUGADOR
func _on_body_entered(_body):
	hide() # El jugador desaparece
	hit.emit() # Emitimos la señal "hit"
	# Desactivamos la colisión para no morir mil veces seguidas
	$CollisionShape2D.set_deferred("disabled", true)

# 4. AÑADE ESTA FUNCIÓN PARA REINICIAR AL JUGADOR
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
