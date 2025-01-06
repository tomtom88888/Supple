extends Control

@onready var line_edit: LineEdit = $LineEdit
@onready var web_sockets_mangaer = $"../WebSocketsManager"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_join_lobby_button_pressed() -> void:
	if line_edit.text != "debug":
		web_sockets_mangaer.join_adress = line_edit.text
		web_sockets_mangaer.join_lobby_request(line_edit.text)
	else:
		web_sockets_mangaer.debug_ui()
		
