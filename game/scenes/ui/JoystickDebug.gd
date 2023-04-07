extends Control

@export var log_unhandled_inputs = false
@export var device_id : int

@onready var texture_rect = $HBoxContainer/MarginContainer/TextureRect
@onready var label_a = $HBoxContainer/GridContainer/LabelA
@onready var label_b = $HBoxContainer/GridContainer/LabelB
@onready var label_x = $HBoxContainer/GridContainer/LabelX
@onready var label_y = $HBoxContainer/GridContainer/LabelY


var input : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	texture_rect.position = input * 20

	if (device_id in ArcadeInputMap.joypadDeviceIds):
		#example multi-controller input using action mappings (polling)
		if Input.is_action_pressed(ArcadeInputMap.a_button_action % device_id):
			label_a.add_theme_color_override("font_color", Color.RED)
		else:
			label_a.remove_theme_color_override("font_color")
		
		if Input.is_action_pressed(ArcadeInputMap.b_button_action % device_id):
			label_b.add_theme_color_override("font_color", Color.RED)
		else:
			label_b.remove_theme_color_override("font_color")
		
	
#example multi-controller input using events
func _unhandled_input(event):
	if event.device != device_id:
		return

	if log_unhandled_inputs:
		print(event)
		
	var joypad_event = event as InputEventJoypadMotion
	if joypad_event:
		if joypad_event.axis == 0:
			input.x = joypad_event.axis_value
		elif joypad_event.axis == 1:
			input.y = joypad_event.axis_value

	var joypad_button_event = event as InputEventJoypadButton
	if joypad_button_event and joypad_button_event.pressed:
		match joypad_button_event.button_index:
			JoyButton.JOY_BUTTON_X:
				label_x.add_theme_color_override("font_color", Color.RED)
			JoyButton.JOY_BUTTON_Y:
				label_y.add_theme_color_override("font_color", Color.RED)
	elif joypad_button_event and not joypad_button_event.pressed:
		match joypad_button_event.button_index:
			JoyButton.JOY_BUTTON_X:
				label_x.remove_theme_color_override("font_color")
			JoyButton.JOY_BUTTON_Y:
				label_y.remove_theme_color_override("font_color")
		
