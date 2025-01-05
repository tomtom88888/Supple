extends Panel

var equation
var difficulty
@onready var animation_player: AnimationPlayer = $YourEqAnimationPlayer
@onready var equation_ob: Control = $Data/Equation
@onready var equation_text: Label = $Data/Equation/EquationText

func _ready() -> void:
	pass
	
	
func play_animation(equation_s: String):
	equation_ob.modulate = Color(1, 1, 1, 0)
	equation = equation_s
	equation_text.text = equation
	animation_player.play("animation_screen_in")
	await get_tree().create_timer(1).timeout
	turn_data_animation()


func turn_data_animation():
	for i in range(1, 101):
		equation_ob.modulate.a = i/100.0
		await get_tree().create_timer(0.01).timeout
	
	await get_tree().create_timer(0.2).timeout
	
	animation_player.play("animation_screen_out")
