extends Node
class_name GameOperator

var playerScores : Dictionary = {}

var bestScoreArray : Array = [100, 90, 80, 70, 60, 50, 40, 30, 20, 10]

enum NameType {NONAME, PACMAN, SISPROJECTS}
var PlayerNameType : NameType = NameType.NONAME
var NoNames = ["Player0", "Player1", "Player2", "Player3"]
var PacmanNames = ["Blinky", "Pinky", "Inky", "Clyde"]
var SISNames = ["SierraDelta", "Parkside", "Chlorine", "Burgerman"]
var playArea : PlayArea = null

var inGame : bool = false

signal onPickUpConsumed(player, pickUp)
signal onPickUpGrabbed(player, pickUp)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize randomization
	randomize()
	load_game()
	PlayerNameType = NameType.NONAME

func set_play_area(area : PlayArea):
	playArea = area

func get_center_point():
	if (playArea == null):
		return get_viewport().get_visible_rect().position + get_viewport().get_visible_rect().size * 0.5
	else:
		return playArea.get_center()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func add_player_score(playerId: int, score : int):
	if (playerScores.has(playerId)):
		playerScores[playerId] += score
	else:
		playerScores[playerId] = score
		
func get_player_score(playerId : int):
	if (playerScores.has(playerId)):
		return playerScores[playerId]
	return 0

#func GoToMainMenu():
func check_best_score():
	var bestscore = FindCurrentBestScore()
	
	var index = -1
	for i in range(0, bestScoreArray.size()):
		if (bestscore > bestScoreArray[i]):
			index = i
			break
			
	# Shift everything down
	if index >= 0:
		for n in range(bestScoreArray.size()-1, index, -1):
			bestScoreArray[n] = bestScoreArray[n-1]
		bestScoreArray[index] = bestscore
		save_game()
	
func FindCurrentBestScore():
	var bestscore = 0
	for scores in playerScores:
		if (playerScores[scores] > bestscore):
			bestscore = playerScores[scores]
	return bestscore

func save_game():
	var save_game_file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	#Serialize the scores.
	var json_string = JSON.stringify(bestScoreArray)
	save_game_file.store_line(json_string)

		# JSON provides a static method to serialized JSON string.
		#var json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		#save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
#
#    # Load the file line by line and process that dictionary to restore
#    # the object it represents.
	var save_game_file = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string = save_game_file.get_line()
#
	# Creates the helper class to interact with JSON
	var json = JSON.new()
#
	# Check if there is any error while parsing the JSON string, skip in case of failure
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		return
		
	bestScoreArray = json.data
	pass

func TogglePlayerNames():
	if (GameCore.PlayerNameType == NameType.NONAME):
		PlayerNameType = NameType.PACMAN
	elif (PlayerNameType == NameType.PACMAN):
		PlayerNameType = NameType.SISPROJECTS
	elif (PlayerNameType == NameType.SISPROJECTS):
		PlayerNameType = NameType.NONAME

func GetPlayerNames():
	if (GameCore.PlayerNameType == NameType.NONAME):
		return NoNames
	elif (PlayerNameType == NameType.PACMAN):
		return PacmanNames
	elif (PlayerNameType == NameType.SISPROJECTS):
		return SISNames
