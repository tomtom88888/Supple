extends Panel

@onready var difficulty_text: Label = $DifficultyText
@onready var difficulty_bar: TextureProgressBar = $DifficultyBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var animation_timer: Timer = $AnimationTimer
@onready var delay_timer: Timer = $DelayTimer

var difficulty = 63
var current_difficulty = 0
var animation_running = false  # Tracks if animation is already running

func _ready() -> void:
	play_animation()
	
	
func play_animation():
	if not animation_running:  # Prevent multiple animations
		animation_running = true
		current_difficulty = 0  # Ensure start at 0
		difficulty_bar.value = current_difficulty
		difficulty_text.text = str(current_difficulty)
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
	if current_difficulty < difficulty:
		timer.start()  # Start incrementing the difficulty bar
	else:
		animation_timer.stop()  # Stop the animation timer
		reset_difficulty()  # Initialize everything


func reset_difficulty():
	if not animation_running:
		print("reset difficulty")
		delay_timer.start()

func _on_delay_timer_timeout() -> void:
	print("delay timer")
	animation_player.play("difficulty_animation_out")
	delay_timer.stop()
