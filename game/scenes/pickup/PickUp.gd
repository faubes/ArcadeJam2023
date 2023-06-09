extends RigidBody2D
class_name PickUp

@export_group("General")
@export var pointValue := 0
@export var size := 10
@export_node_path("PickUpBehaviour") var grabBehaviour
@export_node_path("PickUpBehaviour") var consumeBehaviour
@export var destroyOnGrab : bool = false
@export var destroyOnConsume : bool = true

@export_group("Visual Effects")
var grabParticles : GPUParticles2D = null
var consumeParticles : GPUParticles2D = null

@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var sprite : Sprite2D = $Sprite2D
@onready var asprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var grabbed : bool = false
@onready var rotationSpeed : float =  randf_range(PI * 0.05, PI * 0.5)
@onready var currentRotation : float = 0.0
@onready var initialOffset : Vector2 = self.position - GameCore.get_center_point();

var initialRadius = 0
var toTarget

# Called when the node enters the scene tree for the first time.
func _ready():
	initShape()

func _physics_process(_delta):
	if !grabbed:
		currentRotation += rotationSpeed * _delta
		while (currentRotation > PI * 2.0):
			currentRotation -= PI * 2.0


func _integrate_forces(state):
	if !grabbed:
		var newOffset = initialOffset.rotated(currentRotation)
		var targetPosition : Vector2 = GameCore.get_center_point() + newOffset
		var toTarget = targetPosition - self.position
		state.linear_velocity = toTarget

func initShape():
	# Change the size of the collision shape according to the size setting.
	var circleShape = collisionShape.shape as CircleShape2D
	initialRadius = circleShape.radius
	var targetRadius = size * 0.5
	circleShape.radius = targetRadius
	
	var spriteScale = targetRadius / initialRadius
	sprite.scale = Vector2(spriteScale, spriteScale)
	asprite.scale = Vector2(1.5, 1.5)

func grab(grabbingPlayer : Player):
	grabbed = true
	
	if (grabBehaviour != null):
		(get_node(grabBehaviour) as PickUpBehaviour).perform(self, grabbingPlayer)
	
	# Notify the game operator
	GameCore.onPickUpGrabbed.emit(self, grabbingPlayer)
	
	# Destroy if needed
	if (destroyOnGrab):
		selfDestruct()

func release():
	grabbed = false;
	initialOffset = self.position - GameCore.get_center_point()
	currentRotation = 0.0

func consume(consumingPlayer : Player):
	# Implement what happens when this power up is consumed.
	if (consumeBehaviour != null):
		(get_node(consumeBehaviour) as PickUpBehaviour).perform(self, consumingPlayer)
	
	# Notify the game operator
	GameCore.onPickUpConsumed.emit(self, consumingPlayer)
	
	# Destroy if needed
	if (destroyOnConsume):
		selfDestruct()

func setCollisionEnabled(enabled : bool):
	if (collisionShape != null):
		collisionShape.disabled = !enabled

func selfDestruct():
	GameCore.onPickUpDestroyed.emit(self)
	queue_free()
