extends Panel

@onready var game_started_animation_player: AnimationPlayer = $WinAnimationPlayer
@onready var turn_type_title: Label = $Data/TurnTypeTitle

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_animation():
	game_started_animation_player.play("animation_screen_in")
	await get_tree().create_timer(1.5).timeout
	get_parent().get_parent().switch_scene(load("res://scenes/main_menu.tscn"))
