extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	# Borramos el new_game() de aquí para que el botón del HUD sea el que mande
	pass

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	# Mostramos el mensaje de Game Over en el HUD
	$HUD.show_game_over()
	# Limpiamos la pantalla de enemigos
	get_tree().call_group("mobs", "queue_free")

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	# Actualizamos el HUD al empezar
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func _on_score_timer_timeout():
	score += 1
	# Actualizamos el puntaje cada segundo
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
