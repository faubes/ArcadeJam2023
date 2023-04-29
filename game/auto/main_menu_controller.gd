extends Node2D

enum SelectedMainMenuOption { PlayGame, HighScores, Credits,}
@onready var selectedIndicator = $SelectedIndicator
@onready var buttonList = [$"Play Game", $"High Score", $"Credits"]
@export var SelectedOption = SelectedMainMenuOption.PlayGame
@onready var playGameButton = $"Play Game"

# Called when the node enters the scene tree for the first time.
func _ready():
	SelectedOption = SelectedMainMenuOption.PlayGame
	#selectionNode.set_position(Vector2(100, 100), false)
	#selectedIndicator.set_position(Vector2(0, 0), false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	pass
		#example mapped inputs
#	if event.is_action_pressed("FireHand"):
#		label_a.add_theme_color_override("font_color", Color.RED)
#	if event.is_action_pressed("SelectButton"):
#		label_a.add_theme_color_override("font_color", Color.BLUE)
#	if event.is_action_pressed("ReelIn"):
#		label_a.add_theme_color_override("font_color", Color.DARK_GREEN)
#	if event.is_action_pressed("TiltClockwise"):
#		label_a.add_theme_color_override("font_color", Color.DARK_ORANGE)
#	if event.is_action_pressed("TiltCounterclockwise"):
#		label_a.add_theme_color_override("font_color", Color.PURPLE)
	
