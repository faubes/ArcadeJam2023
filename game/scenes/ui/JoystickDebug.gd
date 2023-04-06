extends Node2D

@onready var texture_rect = $HBoxContainer/MarginContainer/TextureRect
@export var log_unhandled_inputs = false

var input : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#print(Input.get_action_strength("horizontal_axis_0"))
	#var gradient_texture = texture_rect.texture as GradientTexture2D
	#if gradient_texture:
	#	gradient_texture.fill_from = input + Vector2(0.5, 0.5)
	texture_rect.position = input * 20

func _unhandled_input(event):
	if log_unhandled_inputs:
		print(event)
	var joypad_event = event as InputEventJoypadMotion
	if joypad_event:
		if joypad_event.axis == 0:
			input.x = joypad_event.axis_value
		elif joypad_event.axis == 1:
			input.y = joypad_event.axis_value

