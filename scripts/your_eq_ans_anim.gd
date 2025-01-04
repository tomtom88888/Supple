extends Panel

var time_solved_in
var is_right
var difficulty
@onready var time_data_ob: Control = $Data/TimeData
@onready var is_right_ob: Control = $Data/IsRight
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var is_right_text: Label = $Data/IsRight/IsRightText
@onready var your_time_text: Label = $Data/TimeData/TimeSolved/YourTime/YourTimeText
@onready var health_bar_text: Label = $Data/Health/HealthBar/HealthBarText
@onready var difficulty_bar: TextureProgressBar = $Data/Difficulty/DifficultyBar
@onready var difficulty_text: Label = $Data/Difficulty/DifficultyBar/DifficultyText
@onready var difficulty_ob: Control = $Data/Difficulty
@onready var wrong_screen_ob: Control = $Data/WrongScreen

func _ready() -> void:
	pass
	#play_animation(6, false, 20)
	
	
func play_animation(time_solved_in_s: float, is_right_s: bool, difficulty_s: int):
	animation_player.play("animation_screen_in")
	is_right_ob.modulate = Color(1, 1, 1, 1)
	time_data_ob.modulate = Color(1, 1, 1, 0)
	difficulty_ob.modulate = Color(1, 1, 1, 0)
	wrong_screen_ob.modulate = Color(1, 1, 1, 0)
	difficulty_bar.value = 0
	time_solved_in = time_solved_in_s
	is_right = is_right_s
	difficulty = difficulty_s
	animation_player.play("animation_screen_in")
	await get_tree().create_timer(1).timeout
	right_wrong_aniamtion()
	
func right_wrong_aniamtion() -> void:
	var right = false
	for i in range(20):
		right = !right
		if right:
			is_right_text.text = "right"
			is_right_text.add_theme_color_override("font_color", Color.GREEN)
		else:
			is_right_text.text = "wrong"
			is_right_text.add_theme_color_override("font_color", Color.RED)
		await get_tree().create_timer(0.1).timeout
	if is_right:
		is_right_text.text = "right"
		is_right_text.add_theme_color_override("font_color", Color.GREEN)
	else:
		is_right_text.text = "wrong"
		is_right_text.add_theme_color_override("font_color", Color.RED)
	await get_tree().create_timer(0.5).timeout
	if is_right:
		turn_data_animation()
	else:
		for i in range(1, 101):
			wrong_screen_ob.modulate.a = i/100.0
			await get_tree().create_timer(0.01).timeout
		animation_player.play("animation_screen_out")


func turn_data_animation():
	var time_until_switch = 0.01
	var switch_num = 4
	
	for i in range(1, 101):
		time_data_ob.modulate.a = i/100.0
		var random_time = str(randf_range(time_solved_in - 4, time_solved_in + 4)).substr(0, 3)
		your_time_text.text = str(random_time)
		await get_tree().create_timer(0.01).timeout
	
	for i in range(7):
		var random_time = str(randf_range(time_solved_in - switch_num, time_solved_in + switch_num)).substr(0, 3)
		switch_num -= 0.5
		your_time_text.text = str(random_time)
		await get_tree().create_timer(0.01).timeout
	your_time_text.text = str(time_solved_in)
	await get_tree().create_timer(1).timeout

	for i in range(1, 101):
		difficulty_ob.modulate.a = i/100.0
		await get_tree().create_timer(0.01).timeout
	
	while difficulty > difficulty_bar.value:
		difficulty_bar.value += 1
		difficulty_text.text = str(difficulty_bar.value)
		await get_tree().create_timer(0.05).timeout
	difficulty_bar.value = difficulty
	difficulty_text.text = str(difficulty)
	
	await get_tree().create_timer(2).timeout
	
	animation_player.play("animation_screen_out")
