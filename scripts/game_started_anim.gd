extends Panel

@onready var game_started_animation_player: AnimationPlayer = $GameStartedAnimationPlayer
@onready var turn_type_title: Label = $Data/TurnTypeTitle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_animation(turn_type):
	if turn_type == "attack":
		turn_type_title.text = "You Start\n Attacking!"
	elif turn_type == "wait":
		turn_type_title.text = "The Opponent\n Starts Attacking!"
	game_started_animation_player.play("animation_screen_in")
	await get_tree().create_timer(2.5).timeout
	game_started_animation_player.play("animation_screen_out")
