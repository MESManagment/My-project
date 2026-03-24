extends RigidBody2D

func _ready():
	# 1. Añadimos el enemigo al grupo "mobs" para poder borrarlos al morir
	add_to_group("mobs")
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])

# 2. Esta es la función que DEBE estar conectada en la pestaña Signals
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free() # Esto los borra al salir de la pantalla
