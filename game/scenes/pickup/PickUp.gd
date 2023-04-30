extends Node
class_name PickUp

@export_group("General")
@export var pointValue := 0
@export var size := 10
@export var mass := 1
@export var consumeBehaviours : Array[PickUpBehaviour] = []

@export_group("Visual Effects")
@export_node_path("GPUParticles2D") var grabParticles = null
@export_node_path("GPUParticles2D") var consumeParticles = null

@onready var collisionShape = $CollisionShape2D
@onready var sprite = $Sprite2D

var initialSize = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initShape()


func _on_consumed(_playerObject):
	# Implement what happens when this power up is consumed.
	for consumeBehaviour in consumeBehaviours:
		consumeBehaviour.perform(self)
	queue_free()


func initShape():
	# Change the size of the collision shape according to the size setting.
	var circleShape = collisionShape.shape as CircleShape2D
	initialSize = circleShape.radius * 2
	circleShape.radius = size
	
	var spriteScale = size / initialSize
	sprite.scale = Vector2(spriteScale, spriteScale)
