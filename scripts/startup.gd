extends Node2D

const SERVER_PORT = 8080
const SERVER_IP = "127.0.0.1"

const MAIN_MENU = "res://scenes/main_menu.tscn"
const GAME = "res://scenes/game.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("deticated_server"):
		_on_host_pressed()

func _on_host_pressed():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = peer
	start_game()

func start_game():
	
	if multiplayer.is_server():
		print("Server changing to level scene ...")
		get_parent().switch_scene(load(MAIN_MENU))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
