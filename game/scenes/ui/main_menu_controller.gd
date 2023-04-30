extends Node2D

enum SelectedMainMenuOption { PLAY_GAME, HIGH_SCORES, CREDITS}
@onready var ButtonList = [$"Main Menu/Play Game", $"Main Menu/High Score", $"Main Menu/Credits"]
@export var SelectedOption = SelectedMainMenuOption.PLAY_GAME
@onready var SelectedButton = $"Main Menu/SelectedIndicator"
@onready var MainMenu = $"Main Menu"
@onready var HighScores = $"High Scores"
@onready var Credits = $Credits
@onready var ReadyList = [false, false, false, false]
@onready var ReadyIndicatorList = [$"Main Menu/Player Ready Container/Player0/Player0 Ready",
$"Main Menu/Player Ready Container/Player1/Player1 Ready",
$"Main Menu/Player Ready Container/Player2/Player2 Ready",
$"Main Menu/Player Ready Container/Player3/Player3 Ready"]



# Called when the node enters the scene tree for the first time.
func _ready():
	ResetMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if !MainMenu.is_visible() && !Credits.is_visible() && !HighScores.is_visible():
		return
		
	#Menu Inputs
	if event.is_action_pressed("MenuUp") && MainMenu.is_visible():
		NavigateMenu(true)
	if event.is_action_pressed("MenuDown") && MainMenu.is_visible():
		NavigateMenu(false)
	if event.is_action_pressed("SelectButton") && MainMenu.is_visible():
		if SelectedOption == SelectedMainMenuOption.PLAY_GAME:
			StartGame()
		elif SelectedOption == SelectedMainMenuOption.HIGH_SCORES:
			MainMenu.set_visible(false)
			HighScores.set_visible(true)
		elif SelectedOption == SelectedMainMenuOption.CREDITS:
			MainMenu.set_visible(false)
			Credits.set_visible(true)
	if event.is_action_pressed("ReadyPlayer"):
		if MainMenu.is_visible():
			ToggleReadyIndicator(event.device)
		else:
			ResetMenu()

func NavigateMenu(up: bool):
	if (up && SelectedOption != SelectedMainMenuOption.PLAY_GAME):
		SelectedOption = SelectedOption - 1 as SelectedMainMenuOption
	elif (!up && SelectedOption != SelectedMainMenuOption.CREDITS):
		SelectedOption = SelectedOption + 1 as SelectedMainMenuOption
	SelectedButton.set_position(ButtonList[SelectedOption].position)
	SelectedButton.set_size(ButtonList[SelectedOption].size)
	
func ResetMenu():
	SelectedOption = SelectedMainMenuOption.PLAY_GAME
	#Set initial button position.
	NavigateMenu(true)
	MainMenu.set_visible(true)
	HighScores.set_visible(false)
	Credits.set_visible(false)
	# Reset ready players
	ReadyList = [false, false, false, false]
	ShowReadyIndicators()

func ShowReadyIndicators():
	for i in range(0, ReadyList.size()):
		ReadyIndicatorList[i].set_visible(ReadyList[i])

func ToggleReadyIndicator(playerId : int):
	ReadyList[playerId] = !ReadyList[playerId]
	ShowReadyIndicators()

func StartGame():
	$"Main Menu".set_visible(false)
	#Some event up to Game Manager to pass along the ready player list.

func save_game():
	var save_game = FileAccess.open("res://savegame.save", FileAccess.WRITE)


		# JSON provides a static method to serialized JSON string.
		#var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		#save_game.store_line(json_string)

#func load_game():
#    if not FileAccess.file_exists("user://savegame.save"):
#        return # Error! We don't have a save to load.
#
#    # We need to revert the game state so we're not cloning objects
#    # during loading. This will vary wildly depending on the needs of a
#    # project, so take care with this step.
#    # For our example, we will accomplish this by deleting saveable objects.
#    var save_nodes = get_tree().get_nodes_in_group("Persist")
#    for i in save_nodes:
#        i.queue_free()
#
#    # Load the file line by line and process that dictionary to restore
#    # the object it represents.
#    var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
#    while save_game.get_position() < save_game.get_length():
#        var json_string = save_game.get_line()
#
#        # Creates the helper class to interact with JSON
#        var json = JSON.new()
#
#        # Check if there is any error while parsing the JSON string, skip in case of failure
#        var parse_result = json.parse(json_string)
#        if not parse_result == OK:
#            print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
#            continue
#
#        # Get the data from the JSON object
#        var node_data = json.get_data()
#
#        # Firstly, we need to create the object and add it to the tree and set its position.
#        var new_object = load(node_data["filename"]).instantiate()
#        get_node(node_data["parent"]).add_child(new_object)
#        new_object.position = Vector2(node_data["pos_x"], node_data["pos_y"])
#
#        # Now we set the remaining variables.
#        for i in node_data.keys():
#            if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y":
#                continue
#            new_object.set(i, node_data[i])
