extends StaticBody2D

@onready var spring_arm = $SpringArm
@onready var claw = $SpringArm/Claw

var player_id : int = 0
enum hand_state { closed, open }
enum arm_state { retracted, extending, retracting }

var current_hand_state : hand_state = hand_state.closed
var current_arm_state : arm_state = arm_state.retracted

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _input(event):
	if event.device != player_id:
		return
	
	claw.apply_force(Vector2(50,0))
	
