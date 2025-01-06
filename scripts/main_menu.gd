extends Control

@onready var web_sockets_manager: Node2D = $"../WebSocketsManager"
@onready var line_edit: LineEdit = $LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	web_sockets_manager.username = line_edit.text


func _on_find_match_button_pressed() -> void:
	get_parent().switch_scene(load("res://scenes/tournament_menu.tscn"))

func _on_v_1_button_pressed() -> void:
		get_parent().switch_scene(load("res://scenes/tournament_menu.tscn"))
