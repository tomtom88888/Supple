extends Node2D

var socket = WebSocketPeer.new()
var last_state = WebSocketPeer.STATE_CLOSED
var join_adress
var found_match
var username = "Anonymous"
var debugging = false

@export var join_http_request: HTTPRequest
#@export var delete_http_request: HTTPRequest

const ip = "95.35.170.58:8000"
const url = "http://95.35.170.58:8000/join_match"
#const ip = "localhost:8000"
#const host_url = "http://localhost:8000/host_match"
#const delete_url = "http://95.35.170.58:8000/delete_lobby/"

signal connected_to_server()
signal connection_closed()
signal message_received(message: Variant)

var your_player_id
var game_started
var enemy_attack_time = 0
var game
var your_attack_time
var first_time = true
var updated_turn

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
	join_http_request.request_completed.connect(_on_request_completed)

func _on_message_received(message: Variant) -> void:
	var json = JSON.parse_string(message)
	print(json)
	if json["action"] == "start":
		game_started = true
		your_player_id = json["id"]
		game = get_parent().switch_to_scene_no_anim(load("res://scenes/game.tscn"))
	if game_started:
		if json["action"] == "update_turn":
			if first_time:
				first_time = false
				game.on_game_started(json["turn"])
			game.turn_type = json["turn"]
		if json["action"] == "submitted_equation":
			if json["player"] == your_player_id:
				game.on_attack_answer_submitted(json["time"], json["correct"], json["diffculty"])
			else:
				game.on_opponent_attack_answer_submitted(json["time"], json["correct"], json["diffculty"], json["original_equation"])
		elif json["action"] == "submitted_defense":
			if json["player"] == your_player_id:
				game.on_defense_answer_submitted(json["time"], json["original_time"], json["correct"], json["health"], json["damage"])
			else:
				game.on_opponent_defense_answer_submitted(json["time"], json["original_time"], json["correct"], json["health"], json["damage"])
		elif json["action"] == "end_game":
			if json["winner"] == your_player_id:
				game.on_won_game()
			else:
				game.on_lost_game()
				
func _on_connected_to_server() -> void:
	print("Connected To Server")

func _connection_closed() -> void:
	print("Connection Closed")

func _process(delta: float) -> void:
	poll()

func send_join_rquest():
	get_parent().switch_scene(load("res://scenes/finding_1v1_lobby.tscn"))
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var client_id = rng.randi_range(0, 1000000)
	var json_body = {"client_id": client_id}
	var headers = ["Content-Type: application/json"]  # Add headers if needed
	var result = join_http_request.request(
		url + "?client_id=" + str(client_id),
		headers,
		HTTPClient.METHOD_POST,
		JSON.stringify(json_body)
	)
	if result != OK:
		print("Error sending request: ", result)
	else:
		print("Request sent successfully")

func _on_request_completed(result, response_code, headers, body):
	print("request completed")
	var json = JSON.parse_string(body.get_string_from_utf8())
	join_adress = json["join_address"]
	print("ws://" + ip + "/ws/" + join_adress)
	var error = connect_to_url("ws://" + ip + "/ws/" + join_adress)
	if error != OK:
		print(error)
