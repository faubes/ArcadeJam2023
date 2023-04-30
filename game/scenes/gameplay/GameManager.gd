extends Node
class_name GameManager

signal onPickUpConsumed(player, pickUp)
signal onPickUpGrabbed(player, pickUp)

static var instance : GameManager = null

static func get_instance():
	return instance

# Called when the node enters the scene tree for the first time.
func _ready():
	if (instance == null):
		instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
