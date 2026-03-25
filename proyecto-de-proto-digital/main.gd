extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	# No llamamos a new_game() aquí para que el botón Start del HUD tenga el control
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	# DETENEMOS la música de fondo y REPRODUCIMOS el sonido de muerte
	$Music.stop()
	$DeathSound.play()
	# Limpiamos la pantalla de enemigos
	get_tree().call_group("mobs", "queue_free")

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	# REPRODUCIMOS la música de fondo al empezar
	$Music.play()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	# Crear una instancia del enemigo
	var mob = mob_scene.instantiate()

	# Elegir un lugar aleatorio en el Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Establecer la dirección del enemigo perpendicular al camino
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position

	# Añadir algo de aleatoriedad a la dirección
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Elegir la velocidad del enemigo
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Añadir el enemigo a la escena principal
	add_child(mob)
