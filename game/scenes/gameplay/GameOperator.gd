extends Node
class_name GameOperator

var playerScores : Dictionary = {}

signal onPickUpConsumed(player, pickUp)
signal onPickUpGrabbed(player, pickUp)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialize randomization
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func add_player_score(playerId: int, score : int):
	if (playerScores.has(playerId)):
		playerScores[playerId] += score
	else:
		playerScores[playerId] = score
		
func get_player_score(playerId : int):
	if (playerScores.has(playerId)):
		return playerScores[playerId]
	return 0
