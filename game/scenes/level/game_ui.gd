extends CanvasLayer

@onready var playerScoreTextList = [$"Player0/Player0 Ready", $"Player1/Player1 Ready", $"Player2/Player2 Ready", $"Player3/Player3 Ready"]
@onready var playerNameTextList = [$Player0, $Player1, $Player2, $Player3]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ($".".is_visible() != GameCore.inGame):
		ChangePlayerNames()
		$".".set_visible(GameCore.inGame)
	
	if (GameCore.inGame):
		# Find the highest score.
		var bestScore = GameCore.FindCurrentBestScore()		
		for i in range(0, playerScoreTextList.size()):
			playerScoreTextList[i].text = str(GameCore.get_player_score(i)) + " points"
			if GameCore.get_player_score(i) == bestScore:
				playerScoreTextList[i].get_label_settings().set_font_color(Color.FOREST_GREEN)
			else:
				playerScoreTextList[i].get_label_settings().set_font_color(Color.RED)

func _input(event):
	if !GameCore.inGame:
		return
	if event.is_action_released("TogglePlayerNames"):
		GameCore.TogglePlayerNames()
		ChangePlayerNames()

func ChangePlayerNames():
	var listOfNames = GameCore.GetPlayerNames()
	for i in range(0, playerNameTextList.size()):
		playerNameTextList[i].text = listOfNames[i]
