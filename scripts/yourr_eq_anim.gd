extends Panel

@onready var eq_data_ob: Control = $EqData
@onready var is_right_ob: Control = $IsRight
@onready var wrong_screen_ob: Control = $WrongScreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $EqData/Timer
@onready var animation_timer: Timer = $EqData/AnimationTimer
@onready var delay_timer: Timer = $EqData/DelayTimer
@onready var is_right_text: Label = $IsRight/IsRightTitle/IsRightText
@onready var time_text: Label = $EqData/Clock/TimeText
@onready var right_wrong_timer: Timer = $EqData/RightWrongTimer
@onready var equation_text: Label = $EqData/EqTitle/EqText
@onready var difficulty_bar: TextureProgressBar = $EqData/DifficultyBar
@onready var difficulty_text: Label = $EqData/DifficultyBar/DifficultyText

var difficulty = 97
var current_difficulty = 0
var is_right
var can_submit = true

func _ready() -> void:
	pass
	
	
func play_animation(difficulty_s, time_solved, equation_s, is_right_s):
	difficulty = difficulty_s
	is_right_ob.visible = true
	eq_data_ob.visible = false
	wrong_screen_ob.visible = false
	current_difficulty = 0  # Ensure start at 0
	is_right = is_right_s
	equation_text.text = equation_s
	time_text.text = str(time_solved)
	difficulty_bar.value = current_difficulty
	difficulty_text.text = str(current_difficulty)
	animation_player.play("animation_screen_in")
	await get_tree().create_timer(1).timeout
	right_wrong_aniamtion()

func _on_timer_timeout() -> void:
	if current_difficulty < difficulty:
		current_difficulty += 1
		difficulty_bar.value = current_difficulty
		difficulty_text.text = str(current_difficulty)
	else:
		timer.stop()

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
	turn_data_animation()

func turn_data_animation():
	if is_right:
		is_right_text.text = "right"
		is_right_text.add_theme_color_override("font_color", "00d23b")
		await get_tree().create_timer(1).timeout
		
		wrong_screen_ob.visible = false
		is_right_ob.visible = false
		eq_data_ob.visible = true
		
		if current_difficulty < difficulty:
			timer.start()  # Start incrementing the difficulty bar
		else:
			await get_tree().create_timer(3).timeout
			animation_player.play("animation_screen_out")
	else:
		is_right_text.text = "wrong"
		is_right_text.add_theme_color_override("font_color", "ff0000")
		await get_tree().create_timer(1).timeout
		wrong_screen_ob.visible = true
		is_right_ob.visible = false
		eq_data_ob.visible = false
		await get_tree().create_timer(3).timeout
		animation_player.play("animation_screen_out")
	await get_tree().create_timer(1).timeout
	can_submit = true

func _on_submit_button_pressed() -> void:
	if can_submit:
		can_submit = false
		play_animation(70, 5, "5 + 3 * 3 - 2", false)
