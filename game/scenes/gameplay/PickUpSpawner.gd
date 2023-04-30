extends Node
class_name PickUpSpawner

@export var minSpawns : int = 5
@export var maxSpawns : int = 20
@export var spawnRadiusFromCenter : float = 100.0
@export var pickUps : Array[PackedScene] = []
@export var spawnWeights : Array[int] = []

@export_node_path("PlayArea") var playAreaPath : NodePath

var playArea : PlayArea = null
var spawnWeightTotal : int = 0
var spawnedPickUps : Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Listen for node destructions
	
	
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
	# Early out if there's nothing to spawn
	if (pickUps == null || pickUps.size() == 0 || spawnWeightTotal == 0):
		return
	
	# Ensure we have our minimum number of spawns
	while (spawnedPickUps.size() < minSpawns):
		spawnNext()

func spawnNext():
	# Choose a pick-up to spawn
	var nextPickup : PackedScene = chooseNextPickUp()
	if (nextPickup == null):
		print("Unable to choose a valid pick-up to spawn.")
		return
	
	# Choose where to spawn the pick-up
	var spawnDistanceFromCenter = randf_range(0.0, spawnRadiusFromCenter)
	var spawnDirection = Vector2.from_angle(randf_range(0.0, PI * 2.0))
	var spawnPosition = playArea.get_center() + (spawnDirection * spawnDistanceFromCenter)
	
	# Spawn the pick-up
	var newPickUp = nextPickup.instantiate() as Node2D;
	newPickUp.position = spawnPosition
	add_child(newPickUp)

func chooseNextPickUp():
	if (spawnWeightTotal == 0):
		return null
	
	# Roll a weight
	var roll = randi() % spawnWeightTotal
	
	var spawnIndex = 0
	while (roll > 0 || spawnWeights[spawnIndex] <= 0):
		if (spawnWeights[spawnIndex] > 0):
			roll -= spawnWeights[spawnIndex]
		
		++spawnIndex
	
	if (spawnIndex < pickUps.size()):
		return pickUps[spawnIndex]
	
	return null
