extends Node

@export_group("General")
@export var pointValue := 0
@export var size := 10
@export var mass := 1
@export var consumeBehaviour : Array[PickUpConsumeBehaviour]

@export_group("Visual Effects")
@export_node_path("GPUParticles2D") var grabParticles = null
@export_node_path("GPUParticles2D") var consumeParticles = null

@onready var collisionBody = $RigidBody2D
@onready var collisionShape = $RigidBody2D/CollisionShape2D
@onready var sprite = $Sprite2D

var initialSize = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initCollider()
	initShape()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_consumed(playerObject):
	# Implement what happens when this power up is consumed.
	
	pass

func initCollider():
	# Change the mass of the collider according to the mass setting.
	collisionBody.mass = mass
	pass

func initShape():
	# Change the size of the collision shape according to the size setting.
	var circleShape = collisionShape.shape as CircleShape2D
	initialSize = circleShape.radius * 2
	circleShape.radius = size
	
	var spriteScale = size / initialSize
	sprite.scale = Vector2(spriteScale, spriteScale)
	pass
