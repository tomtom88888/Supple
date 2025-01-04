extends Node2D

var socket = WebSocketPeer.new()
var last_state = WebSocketPeer.STATE_CLOSED
var join_adress
var found_match

@export var http_request: HTTPRequest

const ip = "0"

signal connected_to_server()
signal connection_closed()
signal message_received(message: Variant)

var your_player_id
var game_started
var enemy_attack_time = 0
var game
var your_attack_time

func poll() -> void:
	if socket.get_ready_state() != socket.STATE_CLOSED:
		socket.poll()
	
	var state = socket.get_ready_state()
	
	if last_state != state:
		last_state = state
		
		if state == socket.STATE_OPEN:
			connected_to_server.emit()
		elif state == socket.STATE_CLOSED:
			connection_closed.emit()
		
	while socket.get_ready_state() == socket.STATE_OPEN and socket.get_available_packet_count():
		message_received.emit(get_message())

func get_message() -> Variant:
	if socket.get_available_packet_count() < 1:
		return null
	
	var packet = socket.get_packet()
	if socket.was_string_packet():
		return packet.get_string_from_utf8()
	
	return bytes_to_var(packet)

func send(message) -> int:
	if typeof(message) == TYPE_STRING:
		return socket.send_text(message)
		
	return socket.send(var_to_bytes(message))

func connect_to_url(url) -> int:
	var error = socket.connect_to_url(url)
	if error != OK:
		return error
		
	last_state = socket.get_ready_state()
	return OK

func close(code := 1000, reason := "") -> void:
	socket.close(code, reason)
	last_state = socket.get_ready_state()
	
func get_socket() -> WebSocketPeer:
	return socket

func _ready() -> void:
	connect("connected_to_server", _on_connected_to_server)
	connect("connection_closed", _connection_closed)
	connect("message_received", _on_message_received)
	http_request.request_completed.connect(_on_request_completed)

func _on_message_received(message: Variant) -> void:
	var json = JSON.parse_string(message)
	if json["action"] == "start":
		game_started = true
		your_player_id = json["id"]
		game = get_parent().switch_scene_and_return(load("res://scenes/game.tscn"))
	if game_started:
		if json["action"] == "update_turn":
			game.turn_type = json["turn"]
		if json["action"] == "submitted_equation":
			if json["player"] == your_player_id:
				game.on_attack_answer_submitted(json["time"], json["correct"], json["difficulty"])
				enemy_attack_time = json["time"]
			else:
				game.on_opponent_attack_answer_submitted(json["time"], json["correct"], json["difficulty"], json["original_equation"])
				your_attack_time = json["time"]
		elif json["action"] == "submitted_defense":
			if json["player"] == your_player_id:
				game.on_defense_answer_submitted(json["time"], enemy_attack_time, json["correct"], json["health"], json["damage"])
			else:
				game.on_opponent_defense_answer_submitted(json["time"], your_attack_time, json["correct"], json["health"], json["damage"])
				
func _on_connected_to_server() -> void:
	pass

func _connection_closed() -> void:
	print("Connection closed")
	
func _process(delta: float) -> void:
	poll()

func send_join_rquest():
	http_request.request("https://api.github.com/repos/godotengine/godot/releases/latest")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	join_adress = json["join_adress"]
	connect_to_url("ws://" + ip + "/ws/" + join_adress)
	get_parent().switch_scene(load("res://scenes/finding_match.tscn"))
