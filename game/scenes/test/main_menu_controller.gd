extends Node2D

enum SelectedMainMenuOption { PLAY_GAME, HIGH_SCORES, CREDITS}
@onready var ButtonList = [$"Main Menu/Play Game", $"Main Menu/High Score", $"Main Menu/Credits"]
@export var SelectedOption = SelectedMainMenuOption.PLAY_GAME
@onready var SelectedButton = $"Main Menu/SelectedIndicator"
@onready var MainMenu = $"Main Menu"

# Called when the node enters the scene tree for the first time.
func _ready():
	SelectedOption = SelectedMainMenuOption.PLAY_GAME
	SelectedButton.set_position(ButtonList[SelectedOption].position)
	#selectedIndicator.set_position(Vector2(0, 0), false)

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
		$"Main Menu".set_visible(false)
	

func NavigateMenu(up):
	if (up && SelectedOption != SelectedMainMenuOption.PLAY_GAME):
		SelectedOption = SelectedOption - 1
	elif (!up && SelectedOption != SelectedMainMenuOption.CREDITS):
		SelectedOption = SelectedOption + 1
	SelectedButton.set_position(ButtonList[SelectedOption].position)
	
