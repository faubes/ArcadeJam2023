extends HBoxContainer

@export var log_unhandled_inputs = true
@export var device_id : int

@onready var texture_rect = $MarginContainer/TextureRect
@onready var label_a = $MarginContainer2/GridContainer/LabelA
@onready var label_b = $MarginContainer2/GridContainer/LabelB
@onready var label_x = $MarginContainer2/GridContainer/LabelX
@onready var label_y = $MarginContainer2/GridContainer/LabelY


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
		if Input.is_action_just_released(ArcadeInputMap.a_button_action % device_id):
			label_a.remove_theme_color_override("font_color")
		
		if Input.is_action_pressed(ArcadeInputMap.b_button_action % device_id):
			label_b.add_theme_color_override("font_color", Color.RED)
		if Input.is_action_just_released(ArcadeInputMap.b_button_action % device_id):
			label_b.remove_theme_color_override("font_color")
		
func _input(event):
	if event.device != device_id:
		return
		
		#example mapped inputs
	if event.is_action_pressed("FireHand"):
		label_a.add_theme_color_override("font_color", Color.RED)
	if event.is_action_pressed("SelectButton"):
		label_a.add_theme_color_override("font_color", Color.BLUE)
	if event.is_action_pressed("ReelIn"):
		label_a.add_theme_color_override("font_color", Color.DARK_GREEN)
	if event.is_action_pressed("TiltClockwise"):
		label_a.add_theme_color_override("font_color", Color.DARK_ORANGE)
	if event.is_action_pressed("TiltCounterclockwise"):
		label_a.add_theme_color_override("font_color", Color.PURPLE)
	
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
		if joypad_event.axis == 1:
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
		
