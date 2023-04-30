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
@onready var grabbed : bool = false
@onready var rotationSpeed : float = randf_range(PI * 0.125, PI * 1.0)
@onready var currentRotation : float = 0.0
@onready var initialOffset : Vector2 = self.position - GameCore.get_center_point();

var initialRadius = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	initShape()

func _process(_delta):
	if (!grabbed):
		currentRotation += rotationSpeed * _delta
		while (currentRotation > PI * 2.0):
			currentRotation -= PI * 2.0
		
		var newOffset = initialOffset.rotated(currentRotation)
		self.position = GameCore.get_center_point() + newOffset;
	

func initShape():
	# Change the size of the collision shape according to the size setting.
	var circleShape = collisionShape.shape as CircleShape2D
	initialRadius = circleShape.radius
	var targetRadius = size * 0.5
	circleShape.radius = targetRadius
	
	var spriteScale = targetRadius / initialRadius
	sprite.scale = Vector2(spriteScale, spriteScale)

func grab(grabbingPlayer : Player):
	grabbed = true
	
	if (grabBehaviour != null):
		(get_node(grabBehaviour) as PickUpBehaviour).perform(self, grabbingPlayer)
	
	# Notify the game operator
	GameCore.onPickUpGrabbed.emit()
	
	# Destroy if needed
	if (destroyOnGrab):
		queue_free()

func release():
	grabbed = false;
	initialOffset = self.position - GameCore.get_center_point()
	currentRotation = 0.0

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
