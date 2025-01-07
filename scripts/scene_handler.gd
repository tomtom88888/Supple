extends Control

@export var current_scene: Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func switch_scene(scene):
	animation_player.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	current_scene.queue_free()
	current_scene = scene.instantiate()
	animation_player.play("fade_out")
	add_child(current_scene)

func switch_scene_and_return(scene) -> Control:
	current_scene.queue_free()
	current_scene = scene.instantiate()
	animation_player.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	add_child(current_scene)
	return current_scene
	animation_player.play("fade_out")


func reload_current_scene():
	animation_player.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	var prev_reload_scene = current_scene.instantiate()
	current_scene.queue_free()
	current_scene = prev_reload_scene
	animation_player.play("fade_out")
	add_child(current_scene)

func to_prev_scene():
	animation_player.play("fade_in")
	await get_tree().create_timer(0.5).timeout
	current_scene.queue_free()
	animation_player.play("fade_out")
	add_child(current_scene)

func switch_to_scene_no_anim(scene):
	current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)
	return current_scene
