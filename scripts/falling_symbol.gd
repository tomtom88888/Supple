extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

var dragging = false

var sprites_list = [preload("res://sprites/Divide.png"), preload("res://sprites/Multiply.png"), preload("res://sprites/Minus.png"), preload("res://sprites/Plus.png")]

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	sprite_2d.texture = sprites_list[rng.randi_range(0, 3)]
	rotation = rng.randf_range(0, 360)

func _process(delta):
	if dragging:
		var mousepos = get_viewport().get_mouse_position()
		self.position = Vector2(mousepos.x, mousepos.y)

func set_drag_pc():
	dragging=!dragging

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			set_drag_pc()
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			set_drag_pc()
	elif event is InputEventScreenTouch:
		if event.pressed and event.get_index() == 0:
			self.position = event.get_position()
