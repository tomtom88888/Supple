extends Control

@onready var web_scokets_manger = $"../WebSocketsManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_join_match_pressed() -> void:
	get_parent().switch_scene(load("res://scenes/join_lobby.tscn"))


func _on_host_match_pressed() -> void:
	web_scokets_manger.send_host_lobby_request()
