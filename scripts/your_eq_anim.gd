extends Panel

var equation
var difficulty
@onready var time_data_ob: Control = $Data/TimeData
@onready var animation_player: AnimationPlayer = $YourEqAnimationPlayer
@onready var is_right_text: Label = $Data/IsRight/IsRightText
@onready var difficulty_bar: TextureProgressBar = $Data/Difficulty/DifficultyBar
@onready var difficulty_text: Label = $Data/Difficulty/DifficultyBar/DifficultyText
@onready var difficulty_ob: Control = $Data/Difficulty
@onready var equation_ob: Control = $Data/Equation
@onready var equation_text: Label = $Data/Equation/EquationText

func _ready() -> void:
	play_animation("5 * 3")
	
	
func play_animation(equation_s: String):
	equation_ob.modulate = Color(1, 1, 1, 0)
	equation = equation_s
	animation_player.play("animation_screen_in")
	await get_tree().create_timer(1).timeout
	turn_data_animation()


func turn_data_animation():
	for i in range(1, 101):
		equation_ob.modulate.a = i/100.0
		await get_tree().create_timer(0.01).timeout
	
	await get_tree().create_timer(1).timeout
	
	animation_player.play("animation_screen_out")
