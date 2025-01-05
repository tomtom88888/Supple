extends Control
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

var stop_count_up
var stop_timer
var prev_time
var turn_type = ""
var current_time = 0
var enemy_time = 0
var submitted_equation
var equation
var enemy_equation
var your_attack_time
var timer_on
var counting_up = true

func _ready() -> void:
	submitted_equation = false

func _process(delta: float) -> void:
	if turn_type == "defend" and prev_time != null:
		set_enemy_equation(enemy_equation)
		#to much time
		#current_time = TimeElapsed.time_elapsed - prev_time
		#if current_time > enemy_time:
			#web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": 0, "action": "submit_defend", "solution": str(-9488961.42524)}))
	elif turn_type == "defend":
		timer_on = false
		set_enemy_equation(enemy_equation)
	elif turn_type == "attack":
		set_enemy_equation("It Is Now Your Turn To Attack")
		if not timer_on:
			equation_writing_timer()
			timer_on = true
	else:
		set_enemy_equation("Wait")
		timer_on = false
		
func on_opponent_attack_answer_submitted(time_solved_in_s: float, is_right_s: bool, difficulty_s: int, equation_s: String):
	stop_timer = true
	stop_count_up = true
	op_eq_anim.play_animation(time_solved_in_s, is_right_s, difficulty_s, equation_s)
	enemy_equation = equation_s
	enemy_time = time_solved_in_s
	
		
func _on_op_eq_animation_player_current_animation_changed(name: String) -> void:
	if name == "animation_screen_out":
		stop_timer = false
		stop_count_up = false
		prev_time = TimeElapsed.time_elapsed
		count_down(enemy_time)


func on_attack_answer_submitted(time_solved_in_s: float, is_right_s: bool, difficulty_s: int):
	stop_timer = true
	stop_count_up = true
	print("attack anim")
	var time_took_to_solve = current_time
	your_eq_ans_anim.play_animation(time_solved_in_s, is_right_s, difficulty_s)
	stop_timer = false
	your_attack_time = time_solved_in_s
	set_difficulty(difficulty_s)

func _on_your_eq_ans_animation_player_current_animation_changed(name: String) -> void:
	if name == "animation_screen_out":
		stop_timer = false
		stop_count_up = false
		count_down(your_attack_time)

func on_defense_answer_submitted(time_solved_in_s: float, time_enemy_solved_in_s: float, is_right_s: bool, health_s: int, damage_s: int):
	stop_timer = true
	stop_count_up = true
	#make timing logic
	your_ans_op_eq_anim.play_animation(time_solved_in_s, time_enemy_solved_in_s, is_right_s, health_s, damage_s)
	equation_writing_timer()
	set_health(health_s, damage_s)

func _on_your_ans_op_eq_animation_player_current_animation_changed(name: String) -> void:
	if name == "animation_screen_out":
		stop_timer = false
		stop_count_up = false
		prev_time = TimeElapsed.time_elapsed

func on_opponent_defense_answer_submitted(time_solved_in_s: float, time_enemy_solved_in_s: float, is_right_s: bool, health_s: int, damage_s: int):
	stop_timer = true
	stop_count_up = true
	op_ans_your_eq_anim.play_animation(time_solved_in_s, time_enemy_solved_in_s, is_right_s, health_s, damage_s)
	equation_writing_timer()
	set_enemy_health(health_s, damage_s)

func _on_op_ans_your_eq_animation_player_animation_changed(old_name: StringName, new_name: StringName) -> void:
	if name == "animation_screen_out":
		stop_timer = false
		stop_count_up = false

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

func count_down(time):
	var current_time = time
	while current_time > 0:
		time_text.text = str(snappedf(current_time, 0.01))
		current_time -= 0.01
		if stop_timer:
			return
		await get_tree().create_timer(0.01).timeout

func count_up():
	var time = 0
	while counting_up:
		print(time)
		time_text.text = str(time)
		time += 0.01
		if stop_count_up:
			return
		await get_tree().create_timer(0.01).timeout


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

func equation_writing_timer():
	var current_time = 60
	while current_time > 0:
		time_text.text = str(current_time)
		if stop_timer == true:
			return
		await get_tree().create_timer(1).timeout
		current_time -= 1
	if turn_type == "attack":
		web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": 0, "action": "submit_equation", "equation": "0 = 1"}))


func equation_not_valid():
	not_valid_animation_player.play("EquationNotValidAnim")
	
func _on_submit_button_pressed() -> void:
	if turn_type == "attack":
		if not submitted_equation:
			stop_timer = true
			equation = your_equation.text
			for c in equation:
				if c not in "+-/*0123456789.=() ":
					print(c)
					equation_not_valid()
					return
			your_equation.text = ""
			your_eq_anim.play_animation(equation)
			your_equation_text.text = str(equation)
			submitted_equation = true
		else:
			counting_up = false
			var answer = your_equation.text
			for c in answer:
				if c not in "0123456789.- ":
					equation_not_valid()
					return
			var time_took_to_solve = TimeElapsed.time_elapsed - prev_time
			submitted_equation = false
			web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": snappedf(time_took_to_solve, 0.01), "action": "submit_equation", "equation": str(equation) + " = " + str(answer)}))
			your_equation_text.text = "Your Equation:"
	elif turn_type == "defend":
		var answer = your_equation.text
		for c in answer:
			if c not in "0123456789.- ":
				equation_not_valid()
				return
		var time_took_to_solve = TimeElapsed.time_elapsed - prev_time
		web_sockets_manager.send(JSON.stringify({"player": web_sockets_manager.your_player_id, "time": time_took_to_solve, "action": "submit_defend", "solution": str(answer)}))
		#send answer to beckend

func _on_your_eq_animation_player_current_animation_changed(name: String) -> void:
	if name == "animation_screen_out":
		print("out")
		count_up()
		prev_time = TimeElapsed.time_elapsed
