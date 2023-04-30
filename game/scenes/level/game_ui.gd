extends CanvasLayer

@onready var playerScoreTextList = [$"Player0/Player0 Ready", $"Player1/Player1 Ready", $"Player2/Player2 Ready", $"Player3/Player3 Ready"]
@onready var playerNameTextList = [$Player0, $Player1, $Player2, $Player3]

@onready var red_label = $RedLabel
@onready var green_label = $GreenLabel

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
			var playerScore = GameCore.get_player_score(i)
			if playerScore >= bestScore:
				playerScoreTextList[i].set_label_settings(green_label.get_label_settings())
			else:
				playerScoreTextList[i].set_label_settings(red_label.get_label_settings())

func _input(event):
	if !GameCore.inGame:
		return
	if event.is_action_released("TogglePlayerNames"):
		GameCore.TogglePlayerNames()
		ChangePlayerNames()
		GameCore.add_player_score(0, 10)

func ChangePlayerNames():
	var listOfNames = GameCore.GetPlayerNames()
	for i in range(0, playerNameTextList.size()):
		playerNameTextList[i].text = listOfNames[i]
