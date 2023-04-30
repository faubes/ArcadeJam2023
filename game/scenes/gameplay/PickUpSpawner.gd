extends Node
class_name PickUpSpawner

@export var minSpawns : int = 5
@export var maxSpawns : int = 20
@export var spawnRadiusFromCenter : float = 100.0
@export var pickUps : Array[PickUp] = []
@export var spawnWeights : Array[int] = []

@export_node_path("PlayArea") var playAreaPath : NodePath

var playArea : PlayArea = null
var spawnWeightTotal : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Cache the play area
	if (playAreaPath != null):
		playArea = get_node(playAreaPath) as PlayArea
	
	# Fill out the spawn weights
	while (spawnWeights.size() < pickUps.size()):
		spawnWeights.append(0)
	
	# Compute the total weights for all pick-up spawns
	spawnWeightTotal = 0
	for weight in spawnWeights:
		spawnWeightTotal += weight
	
	# Clamp the spawn area to the play area
	var maxRadius = playArea.get_inner_radius()
	if (spawnRadiusFromCenter <= 0 || (spawnRadiusFromCenter > maxRadius)):
		spawnRadiusFromCenter = maxRadius

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func spawnNext():
	var nextPickup = chooseNextPickUp()
	
	# TODO eric: Implement

func chooseNextPickUp():
	# Roll a weight
	var roll = randi() % spawnWeightTotal
	
	# TODO eric: Implement
