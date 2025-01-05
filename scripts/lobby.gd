extends Control

@onready var title: Label = $Title
@onready var web_sockets_manager = $"../WebSocketsManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title.text = "Join Code: " + web_sockets_manager.join_adress


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
