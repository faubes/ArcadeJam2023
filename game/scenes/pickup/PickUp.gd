extends Node
class_name PickUp

@export_group("General")
@export var pointValue := 0
@export var size := 10
@export var mass := 1
@export_node_path("PickUpBehaviour") var grabBehaviour
@export_node_path("PickUpBehaviour") var consumeBehaviour
@export var destroyOnGrab : bool = false
@export var destroyOnConsume : bool = true

@export_group("Visual Effects")
var grabParticles : GPUParticles2D = null
var consumeParticles : GPUParticles2D = null

@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D

var initialSize = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initShape()

func initShape():
	# Change the size of the collision shape according to the size setting.
	var circleShape = collisionShape.shape as CircleShape2D
	initialSize = circleShape.radius * 2
	circleShape.radius = size
	
	var spriteScale = size / initialSize
	sprite.scale = Vector2(spriteScale, spriteScale)

func grab(grabbingPlayer : Player):
	if (grabBehaviour != null):
		(get_node(grabBehaviour) as PickUpBehaviour).perform(self, grabbingPlayer)
	
	# Notify the game operator
	GameCore.onPickUpGrabbed.emit()
	
	# Destroy if needed
	if (destroyOnGrab):
		queue_free()

func consume(consumingPlayer : Player):
	# Implement what happens when this power up is consumed.
	if (consumeBehaviour != null):
		(get_node(consumeBehaviour) as PickUpBehaviour).perform(self, consumingPlayer)
	
	# Notify the game operator
	GameCore.onPickUpConsumed.emit()
	
	# Destroy if needed
	if (destroyOnConsume):
		queue_free()

func setCollisionEnabled(enabled : bool):
	if (collisionShape != null):
		collisionShape.disabled = !enabled
