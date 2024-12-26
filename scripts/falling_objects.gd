extends Node2D
const FALLING_SYMBOL = preload("res://scenes/falling_symbol.tscn")
@onready var spawn_timer: Timer = $SpawnTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func spaw_symbol():
	var f = FALLING_SYMBOL.instantiate()
	f.position = Vector2(randf_range(100, 986),-200)
	add_child(f)


func _on_spawn_timer_timeout() -> void:
	spaw_symbol()
