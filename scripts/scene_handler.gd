extends Control

@export var current_scene: Control

func switch_scene(scene):
	current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)

func switch_scene_and_return(scene) -> Control:
	current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)
	return current_scene

func reload_current_scene():
	var prev_scene = current_scene.instantiate()
	current_scene.queue_free()
	current_scene = prev_scene
	add_child(current_scene)
