extends Node2D


var current_scene

func _ready() -> void:
	current_scene = get_child(0)

func switch_scene(scene):
	current_scene.queue_free()
	current_scene = scene.instantiate()
	add_child(current_scene)

func reload_current_scene():
	var prev_scene = current_scene.instantiate()
	current_scene.queue_free()
	current_scene = prev_scene
	add_child(current_scene)
