extends Panel

var time_solved_in
var time_enemy_solved_in
var current_difficulty
var is_right
@onready var next_event_text: Label = $Data/NextEventText
@onready var time_data_ob: Control = $Data/TimeData
@onready var is_right_ob: Control = $Data/IsRight
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var is_right_text: Label = $Data/IsRight/IsRightText
@onready var your_time_text: Label = $Data/TimeData/TimeSolved/YourTime/YourTimeText
@onready var enemy_time_text: Label = $Data/TimeData/EnemyTimeSolved/EnemyTime/EnemyTimeText

func _ready() -> void:
	pass
	
	
func play_animation(time_solved_in_s: float, time_enemy_solved_in_s: float, is_right_s: bool):
	animation_player.play("animation_screen_in")
	is_right_ob.modulate = Color(0, 0, 100, 1)
	time_data_ob.modulate = Color(0, 0, 100, 0)
	next_event_text.modulate = Color(0, 0, 100, 0)
	time_enemy_solved_in = time_enemy_solved_in_s
	time_solved_in = time_enemy_solved_in_s
	is_right = is_right_s
	enemy_time_text.text = time_enemy_solved_in
	
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
	right_wrong_aniamtion()
	await get_tree().create_timer(1).timeout
	
	for i in range(10):
		time_data_ob.modulate.a += i/10
		await get_tree().create_timer(0.1).timeout
	
	for i in range(20):
		your_time_text.text = str(randf_range(clamp(time_enemy_solved_in - 4, 0, time_enemy_solved_in - 4), time_enemy_solved_in + 4))
		await get_tree().create_timer(0.1).timeout
	
	
	

func _on_submit_button_pressed() -> void:
	pass
