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
@onready var MainTitle = $"Main Menu/Title"
@onready var CreditsTitle = $"Credits/Title"
@onready var GameNameList = ["Snip It Up", "Snip, Snip, MotherCrabbers", "Gimme Gimme", "Grabby Crabby", "Claw of the Jungle", "Lay Down The Claw", "Fight Claw", "Fight Clawb"]

@onready var PlayerNameObjects = [$"Main Menu/Player Ready Container/Player0", $"Main Menu/Player Ready Container/Player1", $"Main Menu/Player Ready Container/Player2", $"Main Menu/Player Ready Container/Player3"]
enum NameType {NONAME, PACMAN, SISPROJECTS}
@onready var PlayerNameType : NameType = NameType.NONAME
@onready var NoNames = ["Player0", "Player1", "Player2", "Player3"]
@onready var PacmanNames = ["Blinky", "Pinky", "Inky", "Clyde"]
@onready var SISNames = ["SierraDelta", "Parkside", "Chlorine", "Burgerman"]

# Called when the node enters the scene tree for the first time.
func _ready():
	ResetMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if !MainMenu.is_visible() && !Credits.is_visible() && !HighScores.is_visible():
		return
		
	if GameCore.inGame:
		return
		
	#Menu Inputs
	if event.is_action_pressed("MenuUp") && MainMenu.is_visible():
		NavigateMenu(true)
	if event.is_action_pressed("MenuDown") && MainMenu.is_visible():
		NavigateMenu(false)
	if event.is_action_released("SelectButton") && MainMenu.is_visible():
		if SelectedOption == SelectedMainMenuOption.PLAY_GAME:
			StartGame()
		elif SelectedOption == SelectedMainMenuOption.HIGH_SCORES:
			MainMenu.set_visible(false)
			HighScores.set_visible(true)
		elif SelectedOption == SelectedMainMenuOption.CREDITS:
			MainMenu.set_visible(false)
			Credits.set_visible(true)
	if event.is_action_released("ReadyPlayer"):
		if MainMenu.is_visible():
			ToggleReadyIndicator(event.device)
		else:
			ResetMenu()
	if event.is_action_released("TogglePlayerNames"):
		TogglePlayerNames()

func NavigateMenu(up: bool):
	if (up && SelectedOption != SelectedMainMenuOption.PLAY_GAME):
		SelectedOption = SelectedOption - 1 as SelectedMainMenuOption
	elif (!up && SelectedOption != SelectedMainMenuOption.CREDITS):
		SelectedOption = SelectedOption + 1 as SelectedMainMenuOption
	SelectedButton.set_position(ButtonList[SelectedOption].position)
	SelectedButton.set_size(ButtonList[SelectedOption].size)
	
func ResetMenu():
	SelectedOption = SelectedMainMenuOption.PLAY_GAME
	GameCore.inGame = false
	
	# Set various game names
	randomize()
	var index = randi_range(0, GameNameList.size()-1)
	MainTitle.text = GameNameList[index]
	CreditsTitle.text = GameNameList[index]
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
	GameCore.inGame = true
	
func TogglePlayerNames():
	if (PlayerNameType == NameType.NONAME):
		PlayerNameType = NameType.PACMAN
		for i in range(0, PlayerNameObjects.size()):
			PlayerNameObjects[i].text = PacmanNames[i]
	elif (PlayerNameType == NameType.PACMAN):
		PlayerNameType = NameType.SISPROJECTS
		for i in range(0, PlayerNameObjects.size()):
			PlayerNameObjects[i].text = SISNames[i]
	elif (PlayerNameType == NameType.SISPROJECTS):
		PlayerNameType = NameType.NONAME
		for i in range(0, PlayerNameObjects.size()):
			PlayerNameObjects[i].text = NoNames[i]
