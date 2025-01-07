extends Control

@onready var line_edit: LineEdit = $LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_join_lobby_button_pressed() -> void:
	if line_edit.text != "debug":
		#web_sockets_mangaer.join_adress = line_edit.text
		#web_sockets_mangaer.join_lobby_request(line_edit.text)
		#send join lobby request code should mention websocket manager
		#switch scenes to finding lobby only after connected to url so switch scenes in websocket manager
		pass
	else:
		#web_sockets_mangaer.debug_ui()
		#you don't have to add debug mode but maybe it will make it easier for you
		pass
