extends Panel

var time_solved_in
var time_enemy_solved_in
var current_difficulty
var is_right
var health
@onready var time_data_ob: Control = $Data/TimeData
@onready var is_right_ob: Control = $Data/IsRight
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var is_right_text: Label = $Data/IsRight/IsRightText
@onready var your_time_text: Label = $Data/TimeData/TimeSolved/YourTime/YourTimeText
@onready var enemy_time_text: Label = $Data/TimeData/EnemyTimeSolved/EnemyTime/EnemyTimeText
@onready var health_bar: TextureProgressBar = $Data/Health/HealthBar
@onready var health_bar_text: Label = $Data/Health/HealthBar/HealthBarText
@onready var health_ob: Control = $Data/Health

func _ready() -> void:
	play_animation(5, 6, true, 20)
	
	
func play_animation(time_solved_in_s: float, time_enemy_solved_in_s: float, is_right_s: bool, health_s: int):
	animation_player.play("animation_screen_in")
	is_right_ob.modulate = Color(255, 255, 255, 1)
	time_data_ob.modulate = Color(255, 255, 255, 0)
	health_bar_text.modulate = Color(255, 255, 255, 0)
	time_enemy_solved_in = time_enemy_solved_in_s
	time_solved_in = time_enemy_solved_in_s
	is_right = is_right_s
	health = health_s
	enemy_time_text.text = str(time_enemy_solved_in)
	animation_player.play("animation_screen_in")
	await get_tree().create_timer(1).timeout
	right_wrong_aniamtion()
	
func right_wrong_aniamtion() -> void:
	var right = false
	for i in range(20):
		right = !right
		if right:
			is_right_text.text = "right"
			is_right_text.add_theme_color_override("font_color", "00d23b")
		else:
			is_right_text.text = "wrong"
			is_right_text.add_theme_color_override("font_color", "ff0000")
		await get_tree().create_timer(0.1).timeout
	if is_right:
		is_right_text.text = "right"
		is_right_text.add_theme_color_override("font_color", "00d23b")
	else:
		is_right_text.text = "wrong"
		is_right_text.add_theme_color_override("font_color", "ff0000")
	turn_data_animation()

func turn_data_animation():
	is_right_text.text = "right"
	is_right_text.add_theme_color_override("font_color", "00d23b")
	await get_tree().create_timer(1).timeout
	
	var time_until_switch = 0.1
	
	for i in range(100):
		time_data_ob.modulate.a += i/100.0
		print(i/100.0)
		var random_time = str(randf_range(time_solved_in - 4, time_solved_in + 4)).substr(0, 3)
		your_time_text.text = str(random_time)
		await get_tree().create_timer(0.01).timeout
	
	for i in range(20):
		var random_time = str(randf_range(time_solved_in - 4, time_solved_in + 4)).substr(0, 3)
		your_time_text.text = str(random_time)
		await get_tree().create_timer(time_until_switch).timeout
		time_until_switch += 0.01
	your_time_text.text = str(time_solved_in)
	await get_tree().create_timer(1).timeout

	for i in range(100):
		health_ob.modulate.a += i/100.0
		await get_tree().create_timer(0.01).timeout
	
	if health > health_bar.value:
		while health_bar.value > health:
			health_bar.value -= 1
			await get_tree().create_timer(0.1).timeout
	else:
		while health_bar.value < health:
			health_bar.value += 1
			await get_tree().create_timer(0.1).timeout
	health_bar_text.text = str(health)
	
	await get_tree().create_timer(2).timeout
	
	animation_player.play("animation_screen_out")
