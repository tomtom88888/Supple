extends Panel

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $EqData/Timer
@onready var animation_timer: Timer = $EqData/AnimationTimer
@onready var delay_timer: Timer = $EqData/DelayTimer
@onready var is_right_text: Label = $IsRight/IsRightTitle/IsRightText
@onready var time_text: Label = $EqData/Clock/TimeText
@onready var is_right_ob: Node2D = $IsRight
@onready var eq_data_ob: Node2D = $EqData
@onready var wrong_screen_ob: Node2D = $WrongScreen
@onready var right_wrong_timer: Timer = $EqData/RightWrongTimer
@onready var equation_text: Label = $EqData/EqTitle/EqText
@onready var difficulty_bar: TextureProgressBar = $EqData/DifficultyBar
@onready var difficulty_text: Label = $EqData/DifficultyBar/DifficultyText

var difficulty = 97
var current_difficulty = 0
var animation_running = false  # Tracks if animation is already running
var switch = true
var right = true
var is_right

func _ready() -> void:
	pass
	
	
func play_animation(difficulty_s, time_solved, equation_s, is_right_s):
	if not animation_running:  # Prevent multiple animations
		print("anim")
		difficulty = difficulty_s
		is_right_ob.visible = true
		eq_data_ob.visible = false
		animation_running = true
		wrong_screen_ob.visible = false
		current_difficulty = 0  # Ensure start at 0
		is_right = is_right_s
		equation_text.text = equation_s
		time_text.text = str(time_solved)
		difficulty_bar.value = current_difficulty
		difficulty_text.text = str(current_difficulty)
		animation_running = true
		animation_player.play("difficulty_animation_in")
		animation_timer.start()

func _on_timer_timeout() -> void:
	if current_difficulty < difficulty:
		current_difficulty += 1
		difficulty_bar.value = current_difficulty
		difficulty_text.text = str(current_difficulty)
	else:
		timer.stop()
		animation_running = false

func _on_animation_timer_timeout() -> void:
	right_wrong_timer.start()
	switch = true
	while switch:
		right = !right
		if right:
			is_right_text.text = "right"
			is_right_text.add_theme_color_override("font_color", "00d23b")
		else:
			is_right_text.text = "wrong"
			is_right_text.add_theme_color_override("font_color", "ff0000")
	if is_right == true:
		is_right_text.text = "right"
		is_right_text.add_theme_color_override("font_color", "ff0000")
		
		wrong_screen_ob.visible = false
		is_right_ob.visible = false
		eq_data_ob.visible = true
		
		if current_difficulty < difficulty:
			timer.start()  # Start incrementing the difficulty bar
		else:
			animation_timer.stop()  # Stop the animation timer
			reset_difficulty()  # Initialize everything
	else:
		is_right_text.text = "wrong"
		is_right_text.add_theme_color_override("font_color", "00d23b")
		wrong_screen_ob.visible = true
		is_right_ob.visible = false
		eq_data_ob.visible = false
		

func reset_difficulty():
	print("reset difficulty")
	delay_timer.start()

func _on_delay_timer_timeout() -> void:
	print("delay timer")
	animation_player.play("difficulty_animation_out")
	delay_timer.stop()

func _on_right_wrong_timer_timeout() -> void:
	switch = false

func _on_submit_button_pressed() -> void:
	play_animation(70, 5, "5 + 3 * 3 - 2", true)
	print("fuck")
