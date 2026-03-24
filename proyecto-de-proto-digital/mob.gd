extends RigidBody2D

func _ready():
	# Elegimos una animación al azar de las 3 que creamos
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# Esta función se activa cuando el enemigo sale de la pantalla
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Borra al enemigo del juego
