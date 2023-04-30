extends Node

var joypadDeviceIds : Array[int]
var deviceMap : Dictionary

var savedScores : Array[int]
var savedPlayerIds : Array[int]

var horizontal_axis_action := "horizontal_axis_%d"
var vertical_axis_action := "vertical_axis_%d"
var a_button_action := "a_button_%d"
var b_button_action := "b_button_%d"
var x_button_action := "x_button_%d"
var y_button_action := "y_button_%d"
var start_button_action := "start_button_%d"
var actions = [horizontal_axis_action, vertical_axis_action, a_button_action, b_button_action, x_button_action, y_button_action, start_button_action]

# Called when the node enters the scene tree for the first time.
func _init():
	joypadDeviceIds = Input.get_connected_joypads()
	print("Detected Joypads: %s" % str(joypadDeviceIds))
	# my controller is detected twice, so checking GUIDs to prevents duplicates
	for joypadDeviceId in joypadDeviceIds:
		var guid := Input.get_joy_guid(joypadDeviceId)
		var joy_name := Input.get_joy_name(joypadDeviceId)
		print("Joy Device GUID: {guid}, Name: {name}".format({"guid" : guid, "name" : joy_name}))
		create_input_map(joypadDeviceId)
	#print(InputMap.get_actions())
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


# define input actions for each device
func create_input_map(id : int):
	for action in actions:
		if InputMap.has_action(action % id):
			print("Failed to create input map for device %d: action already exists" % id)
			return

	print("Creating device mapping for id %d" % id) 
	InputMap.add_action(horizontal_axis_action % id)
	var horizontal_axis_joypad_motion = InputEventJoypadMotion.new()
	horizontal_axis_joypad_motion.device = id
	horizontal_axis_joypad_motion.axis = 0
	InputMap.action_add_event(horizontal_axis_action % id, horizontal_axis_joypad_motion)
	if (id == 0):
		var horizontal_axis_motion = InputEventAction.new()
		horizontal_axis_motion.device = id
	
	InputMap.add_action(vertical_axis_action % id)
	var vertical_axis_joypad_motion = InputEventJoypadMotion.new()
	vertical_axis_joypad_motion.device = id
	vertical_axis_joypad_motion.axis = 1
	InputMap.action_add_event(vertical_axis_action % id, vertical_axis_joypad_motion)
	
	InputMap.add_action(a_button_action % id)
	var a_button = InputEventJoypadButton.new()
	a_button.device = id
	a_button.button_index = JOY_BUTTON_A
	InputMap.action_add_event(a_button_action % id, a_button)
	
	InputMap.add_action(b_button_action % id)
	var b_button = InputEventJoypadButton.new()
	b_button.device = id
	b_button.button_index = JOY_BUTTON_B
	InputMap.action_add_event(b_button_action % id, b_button)
	
	InputMap.add_action(x_button_action % id)
	var x_button = InputEventJoypadButton.new()
	x_button.device = id
	x_button.button_index = JOY_BUTTON_X
	InputMap.action_add_event(x_button_action % id, x_button)
	
	InputMap.add_action(y_button_action % id)
	var y_button = InputEventJoypadButton.new()
	y_button.device = id
	y_button.button_index = JOY_BUTTON_Y
	InputMap.action_add_event(y_button_action % id, y_button)

	InputMap.add_action(start_button_action % id)
	var start_button = InputEventJoypadButton.new()
	start_button.device = id
	start_button.button_index = JOY_BUTTON_START
	InputMap.action_add_event(start_button_action % id, start_button)



func remove_input_map(id : int):
	for action in actions:
		if not InputMap.has_action(action % id):
			print("Failed to remove input map for device %d: action does not exist" % id)
			return
	InputMap.erase_action(horizontal_axis_action % id)
	InputMap.erase_action(vertical_axis_action % id)
	InputMap.erase_action(a_button_action % id)
	InputMap.erase_action(b_button_action % id)
	InputMap.erase_action(x_button_action % id)
	InputMap.erase_action(y_button_action % id)

func compare_this_games_best_score(score : int, playerid : int):
	var indexOfScoreTheNewScoreIsLargerThan = -1
	for n in range(0, savedScores.size()):
		if (score > savedScores[n]):
			indexOfScoreTheNewScoreIsLargerThan = n
		
	if (indexOfScoreTheNewScoreIsLargerThan >= 0):
		for n in range(savedScores.size()-2, indexOfScoreTheNewScoreIsLargerThan, -1):
			savedScores[n+1] = savedScores[n]
			savedPlayerIds[n+1] = savedPlayerIds[n]
		
	savedScores[indexOfScoreTheNewScoreIsLargerThan] = score
	savedPlayerIds[indexOfScoreTheNewScoreIsLargerThan] = playerid

#func saveScores():
#	var save_dict = {
#
#	}
