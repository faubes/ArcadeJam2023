extends Node2D

enum SelectedMainMenuOption { PLAY_GAME, HIGH_SCORES, CREDITS}
@onready var ButtonList = [$"Main Menu/Play Game", $"Main Menu/High Score", $"Main Menu/Credits"]
@export var SelectedOption = SelectedMainMenuOption.PLAY_GAME
@onready var SelectedButton = $"Main Menu/SelectedIndicator"
@onready var MainMenu = $"Main Menu"
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
	if !MainMenu.is_visible():
		return
		
	#Menu Inputs
	if event.is_action_pressed("MenuUp"):
		NavigateMenu(true)
	if event.is_action_pressed("MenuDown"):
		NavigateMenu(false)
	if event.is_action_pressed("SelectButton") && SelectedOption == SelectedMainMenuOption.PLAY_GAME:
		StartGame()
	if event.is_action_pressed("ReadyPlayer"):
		ToggleReadyIndicator(event.device)

func NavigateMenu(up):
	if (up && SelectedOption != SelectedMainMenuOption.PLAY_GAME):
		SelectedOption = SelectedOption - 1
	elif (!up && SelectedOption != SelectedMainMenuOption.CREDITS):
		SelectedOption = SelectedOption + 1
	SelectedButton.set_position(ButtonList[SelectedOption].position)
	SelectedButton.set_size(ButtonList[SelectedOption].size)
	
func ResetMenu():
	SelectedOption = SelectedMainMenuOption.PLAY_GAME
	#Set initial button position.
	NavigateMenu(true)
	# Reset ready players
	ReadyList = [false, false, false, false]
	ShowReadyIndicators()

func ShowReadyIndicators():
	for i in range(0, ReadyList.size()):
		ReadyIndicatorList[i].set_visible(ReadyList[i])

func ToggleReadyIndicator(playerId):
	ReadyList[playerId] = !ReadyList[playerId]
	ShowReadyIndicators()

func StartGame():
	$"Main Menu".set_visible(false)
	#Some event up to Game Manager to pass along the ready player list.
