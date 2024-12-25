extends TextureRect

@onready var time_text: Label = $TimeText

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_time(time: float):
	var i_time = int(time)
	time_text.text = str(i_time)
	
