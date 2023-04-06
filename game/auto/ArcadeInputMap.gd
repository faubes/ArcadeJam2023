extends Node

var joypadDeviceIds : Array[int]

var horizontal_axis_action := "horizontal_axis_%d"
var vertical_axis_action := "vertical_axis_%d"
var a_button_action := "a_button_%d"
var b_button_action := "b_button_%d"
var x_button_action := "x_button_%d"
var y_button_action := "y_button_%d"

# Called when the node enters the scene tree for the first time.
func _init():
	joypadDeviceIds = Input.get_connected_joypads()
	print("Detected Joypads: %s" % str(joypadDeviceIds))
	for joypadDeviceId in joypadDeviceIds:
		create_input_map(joypadDeviceId)
	print(InputMap.get_actions())
	Input.joy_connection_changed.connect(_joy_connection_changed)

func _joy_connection_changed(device : int, connected : bool):
	print("device {id} connected {status}".format({"id" : device, "status" : connected}))
	var deviceFound := device in joypadDeviceIds
	if connected and not deviceFound:
		joypadDeviceIds.append(device)
		create_input_map(device)
		return
	
	if not connected and deviceFound:
		joypadDeviceIds.remove_at(joypadDeviceIds.find(device))
		remove_input_map(device)
		return
	

func create_input_map(id : int):
	print("Creating device mapping for id %d" % id) 
	if not InputMap.has_action(horizontal_axis_action % id):	
		InputMap.add_action(horizontal_axis_action % id)
		InputMap.action_add_event(horizontal_axis_action % id, InputEventJoypadMotion.new())
	else:
		print("Failed to create input map for device %d: action already exists" % id)
		return
	
	InputMap.add_action(vertical_axis_action % id)
	var vertical_axis_joypad_motion = InputEventJoypadMotion.new()
	vertical_axis_joypad_motion.axis = 1
	InputMap.action_add_event(vertical_axis_action % id, vertical_axis_joypad_motion)
	
	InputMap.add_action(a_button_action % id)
	var a_button = InputEventJoypadButton.new()
	a_button.button_index = JOY_BUTTON_A
	InputMap.action_add_event(a_button_action % id, a_button)
	
	InputMap.add_action(b_button_action % id)
	var b_button = InputEventJoypadButton.new()
	b_button.button_index = JOY_BUTTON_B
	InputMap.action_add_event(b_button_action % id, b_button)
	
	InputMap.add_action(x_button_action % id)
	var x_button = InputEventJoypadButton.new()
	x_button.button_index = JOY_BUTTON_X
	InputMap.action_add_event(x_button_action % id, x_button)
	
	InputMap.add_action(y_button_action % id)
	var y_button = InputEventJoypadButton.new()
	y_button.button_index = JOY_BUTTON_Y
	InputMap.action_add_event(y_button_action % id, y_button)


func remove_input_map(id : int):
	if InputMap.has_action(horizontal_axis_action % id):
		InputMap.erase_action(horizontal_axis_action % id)
	
	if InputMap.has_action(vertical_axis_action % id):
		InputMap.erase_action(vertical_axis_action % id)
	
	if InputMap.has_action(a_button_action % id):
		InputMap.erase_action(a_button_action)
	
	if InputMap.has_action(b_button_action % id):
		InputMap.erase_action(b_button_action % id)
	
	if InputMap.has_action(x_button_action % id):
		InputMap.erase_action(x_button_action % id)
	
	if InputMap.has_action(y_button_action % id):
		InputMap.erase_action(y_button_action % id)
