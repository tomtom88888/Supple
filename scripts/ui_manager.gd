extends Control

signal debug_packet(packet: String)

@onready var debug_title: Label = $DebugTitle
@onready var web_sockets_manager: Node2D = $"../WebSocketsManager"
@onready var your_eq_anim: Panel = $YourEqAnim
@onready var not_valid_animation_player: AnimationPlayer = $EquationNotValidAnim/AnimationPlayer
@onready var your_equation: LineEdit = %YourEquation
@onready var difficulty_text: Label = $GameDataBar/DifficultyBar/DifficultyText
@onready var time_text: Label = $GameDataBar/Clock/TimeText
@onready var enemy_health_bar_text: Label = $EnemyHealthBar/EnemyHealthBarText
@onready var enemy_health_bar: TextureProgressBar = $EnemyHealthBar
@onready var enemy_equation_text: Label = $EnemyEquationText
@onready var op_eq_anim: Panel = $OpEqAnim
@onready var difficulty_bar: TextureProgressBar = $GameDataBar/DifficultyBar
@onready var your_eq_ans_anim: Panel = $YourEqAnsAnim
@onready var your_ans_op_eq_anim: Panel = $YourAnsOpEqAnim
@onready var your_health_bar: TextureProgressBar = $YourHealthBar
@onready var your_health_bar_text: Label = $YourHealthBar/YourHealthBarText
@onready var op_ans_your_eq_anim: Panel = $OpAnsYourEqAnim
@onready var your_equation_text: Label = %YourEquationText
@onready var enemy_equation_text_number: Label = $EnemyEquationTextNumber
@onready var submit_button: Button = $SubmitButton
@onready var time_identifier: Label = $GameDataBar/TimeIdentifier
@onready var equation_timer: Timer = $EquationTimer
@onready var game_started_anim: Panel = $GameStartedAnim
@onready var win_anim: Panel = $WinAnim
@onready var lose_anim: Panel = $LoseAnim
@onready var equation_timer_text: Label = $YourEquation/EquationTimerText
@onready var debug_packet_edit: LineEdit = $DebugTitle/DebugPacket

var prev_defense_time
var prev_attack_time
var turn_type = ""
var current_time = 0
var enemy_time = 0
var submitted_equation
var equation
var enemy_equation
var counting_up_timer
var first_time_up
var prev_time_up
var counting_down_timer
var first_time_down
var prev_time_down
var counting_down_time
var enemy_turn
var enemy_health
var your_health
var difficulty
var didnt_write_c
var debugging
var attack_anim_finished



func _ready() -> void:
	your_health = [100, 0]
	enemy_health = [100, 0]
	difficulty = 0
	submitted_equation = false

func on_won_game():
	win_anim.play_animation()
	
func on_lost_game():
	lose_anim.play_animation()

func on_game_started(turn_type):
	game_started_anim.play_animation(turn_type)


func _on_game_started_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animation_screen_out":
		handle_animation_stop()

func _process(delta: float) -> void:
	if turn_type != "attack":
		equation_timer_text.visible = false
		if not submitted_equation:
			equation_timer.stop()
	else:
		equation_timer_text.visible = true
	
	if turn_type == "attack":
		if submitted_equation:
			equation_timer.stop()
	
	
	if not debugging:
		handle_timers()
	
	if debugging:
		debug_title.visible = true
	else:
		debug_title.visible = false
	
	equation_timer_text.text = "Time Left To Write: " + str(equation_timer.time_left).substr(0, 3)
	
	if didnt_write_c == false and attack_anim_finished:
		didnt_write_c = true
		equation_timer.stop()
		equation_timer.start()
	
	if turn_type == "defend":
		time_identifier.text = "Your Time:"
		set_enemy_equation(enemy_equation)
		submit_button.visible = true
			
	elif turn_type == "attack":
		time_identifier.text = "Your Time:"
		set_enemy_equation("It Is Now Your Turn To Attack")
		submit_button.visible = true
	else:
		time_identifier.text = "Hidden Because It's\n The Opponent's turn"
		time_text.text = "Hidden"
		set_enemy_equation("Wait")
		submit_button.visible = false

func handle_timers():
	if counting_up_timer:
		first_time_down = true
		if first_time_up:
			first_time_up = false
			time_text.text = "0"
			prev_time_up = TimeElapsed.time_elapsed
		time_text.text = str(TimeElapsed.time_elapsed - prev_time_up).substr(0, 4)
	elif counting_down_timer:
		first_time_up = true
		if first_time_down:
			first_time_down = false
			time_text.text = "0"
			prev_time_down = TimeElapsed.time_elapsed
		time_text.text = str(counting_down_time - (TimeElapsed.time_elapsed - prev_time_down)).substr(0, 3)
		if counting_down_time - (TimeElapsed.time_elapsed - prev_time_down) <= 0:
			counting_down_timer = false
			if turn_type == "attack":
				web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": 60, "action": "submit_equation", "equation": "0 = 1"}))
			elif turn_type == "defend":
				web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": TimeElapsed.time_elapsed - prev_defense_time, "action": "submit_defend", "solution": randf_range(-10000.0000, 10000.0000)}))
				
func on_opponent_attack_answer_submitted(time_solved_in_s: float, is_right_s: bool, difficulty_s: int, equation_s: String):
	counting_up_timer = false
	counting_down_timer = false
	attack_anim_finished = false
	op_eq_anim.play_animation(time_solved_in_s, is_right_s, difficulty_s, equation_s)
	enemy_turn = "wait"
	enemy_equation = equation_s
	enemy_time = time_solved_in_s

func _on_op_eq_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animation_screen_out":
		time_text.text = "0"
		handle_animation_stop()
		
func on_attack_answer_submitted(time_solved_in_s: float, is_right_s: bool, difficulty_s: int):
	print("attack anim")
	counting_up_timer = false
	counting_down_timer = false
	attack_anim_finished = false
	var time_took_to_solve = current_time
	your_eq_ans_anim.play_animation(time_solved_in_s, is_right_s, difficulty_s)
	difficulty = difficulty_s
	if is_right_s:
		enemy_turn = "defend"
	else:
		enemy_turn = "attack"

func _on_your_eq_ans_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animation_screen_out":
		time_text.text = "0"
		handle_animation_stop()


func on_defense_answer_submitted(time_solved_in_s: float, time_enemy_solved_in_s: float, is_right_s: bool, health_s: int, damage_s: int):
	counting_up_timer = false
	counting_down_timer = false
	attack_anim_finished = false
	#make timing logic
	your_ans_op_eq_anim.play_animation(time_solved_in_s, time_enemy_solved_in_s, is_right_s, health_s, damage_s)
	your_health = [health_s, damage_s]
	enemy_turn = "wait"

func _on_your_ans_op_eq_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animation_screen_out":
		time_text.text = "0"
		handle_animation_stop()
		

func on_opponent_defense_answer_submitted(time_solved_in_s: float, time_enemy_solved_in_s: float, is_right_s: bool, health_s: int, damage_s: int):
	counting_up_timer = false
	counting_down_timer = false
	attack_anim_finished = false
	op_ans_your_eq_anim.play_animation(time_solved_in_s, time_enemy_solved_in_s, is_right_s, health_s, damage_s)
	set_enemy_health(health_s, damage_s)
	enemy_health = [health_s, damage_s]
	enemy_turn = "attack"

func _on_op_ans_your_eq_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animation_screen_out":
		time_text.text = "0"
		handle_animation_stop()
		
func set_enemy_health(health, damage):
	var current_health = health + damage
	if current_health > health:
		while current_health > health:
			current_health -= 1
			enemy_health_bar.value = current_health
			enemy_health_bar_text.text = str(current_health)
			await get_tree().create_timer(0.1).timeout
	elif current_health < enemy_health_bar.value:
		while current_health < enemy_health_bar.value:
			current_health += 1
			enemy_health_bar.value = current_health
			enemy_health_bar_text.text = str(current_health)
			await get_tree().create_timer(0.1).timeout
	enemy_health_bar.value = health

func set_health(health, damage):
	var current_health = health + damage
	if current_health > health:
		while current_health > health:
			current_health -= 1
			your_health_bar.value = current_health
			your_health_bar_text.text = str(current_health)
			await get_tree().create_timer(0.1).timeout
	elif current_health < your_health_bar.value:
		while current_health < your_health_bar.value:
			current_health += 1
			your_health_bar.value = current_health
			your_health_bar_text.text = str(current_health)
			await get_tree().create_timer(0.1).timeout
	your_health_bar.value = health


func set_enemy_equation(equation: String):
	enemy_equation_text_number.text = equation

func set_difficulty(difficulty):
	while difficulty > difficulty_bar.value:
		difficulty_bar.value += 1
		difficulty_text.text = str(difficulty_bar.value)
		await get_tree().create_timer(0.05).timeout
	difficulty_bar.value = difficulty
	difficulty_text.text = str(difficulty)
	
func set_time(time):
	var current_time = 0
	while current_time < time:
		time_text.text = str(current_time)
		current_time += 0.1
		await get_tree().create_timer(0.1).timeout
	time_text.text = current_time

func equation_not_valid():
	not_valid_animation_player.play("EquationNotValidAnim")

func check_equation_validity(equation) -> bool:
	for c in equation:
		if c not in "+-/*0123456789.=(): ":
			return false
	return true

func _on_submit_button_pressed() -> void:
	
	var field_text = your_equation.text
	
	if not check_equation_validity(field_text):
		equation_not_valid()
		return

	if turn_type == "attack":
		if not submitted_equation:
			equation = field_text
			your_equation.text = ""
			counting_down_timer = false
			your_eq_anim.play_animation(equation)
			your_equation_text.text = str(equation)
			submitted_equation = true
		else:
			
			var time_took_to_solve = TimeElapsed.time_elapsed - prev_attack_time
			your_equation.text = ""
			submitted_equation = false
			web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": snappedf(time_took_to_solve, 0.01), "action": "submit_equation", "equation": str(equation) + " = " + str(field_text)}))
			your_equation_text.text = "Your Equation:"
	elif turn_type == "defend":

		var time_took_to_solve = TimeElapsed.time_elapsed - prev_defense_time
		your_equation.text = ""
		web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": time_took_to_solve, "action": "submit_defend", "solution": str(field_text)}))
		#send answer to beckend

func _on_your_eq_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "animation_screen_out":
		prev_attack_time = TimeElapsed.time_elapsed
		time_text.text = "0"
		counting_up_timer = true

func handle_animation_stop():
	first_time_down = true
	first_time_up = true
	set_difficulty(difficulty)
	set_health(your_health[0], your_health[1])
	set_enemy_health(enemy_health[0], enemy_health[1])
	if turn_type == "attack":
		counting_down_time = 60
		counting_down_timer = true
		attack_anim_finished = true
		equation_timer.stop()
		equation_timer.start()
	elif turn_type == "defend":
		prev_defense_time = TimeElapsed.time_elapsed
		counting_down_time = enemy_time
		counting_down_timer = true


func _on_your_equation_text_changed(new_text: String) -> void:
	didnt_write_c = false

func _on_equation_timer_timeout() -> void:
	if not debugging:
		web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": 0, "action": "submit_equation", "equation": "0 = 1"}))
		submitted_equation =  true

func _on_debug_packet_text_submitted(new_text: String) -> void:
	if debugging:
		debug_packet.emit(debug_packet_edit.text)
