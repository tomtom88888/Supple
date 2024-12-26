extends LineEdit

@onready var your_equation: LineEdit = %YourEquation
var input_text: String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	input_text = your_equation.text
