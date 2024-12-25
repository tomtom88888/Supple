extends Node2D

@onready var enemy_equation_text: Label = $"../EnemyEquationText"
@onready var time_text: Label = $"../GameDataBar/Clock/TimeText"
@onready var your_health_bar: TextureProgressBar = $"../YourHealthBar"
@onready var your_health_bar_text: Label = $"../YourHealthBar/YourHealthBarText"
@onready var enemy_health_bar: TextureProgressBar = $"../EnemyHealthBar"
@onready var enemy_health_bar_text: Label = $"../EnemyHealthBar/EnemyHealthBarText"
@onready var difficulty_bar: TextureProgressBar = $"../GameDataBar/DifficultyBar"
@onready var difficulty_text: Label = $"../GameDataBar/DifficultyBar/DifficultyText"

# Called when the node enters the scene tree for the first time.

func lower_time() -> void:
	var num = 60
	while num > 0:
		set_time(num)
		await get_tree().create_timer(1).timeout
		num -= 1


func _ready() -> void:
	lower_time()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func set_time(time: float):
	var i_time = int(time)
	time_text.text = str(i_time)
	
func set_your_health(health: int):
	if health > your_health_bar.value:
		while your_health_bar.value > health:
			your_health_bar.value -= 1
	else:
		while your_health_bar.value < health:
			your_health_bar.value += 1
	your_health_bar_text.text = str(health)

func set_enemy_health(health: int):
	enemy_health_bar.value = health
	enemy_health_bar_text.text = str(health)
	
func set_difficulty(difficulty):
	difficulty_bar.value = difficulty
	difficulty_text.text = str(difficulty)

func set_enemy_equation():
	pass
