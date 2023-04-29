extends StaticBody2D

@onready var groove_joint_2d = $GrooveJoint2D
@onready var claw = $GrooveJoint2D/Claw

@export var min_range = 100
@export var max_range = 200
@export var speed = 20


var player_id : int = 0
enum hand_state { closed, open }
enum arm_state { retracted, extending, retracting }

var current_hand_state : hand_state = hand_state.closed
var current_arm_state : arm_state = arm_state.retracted

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_arm_state(new_state : arm_state):
	if current_arm_state == new_state:
		return
	print("{old} -> {new}".format({"old" : current_arm_state, "new" : new_state}))
	current_arm_state = new_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match current_arm_state:
		arm_state.extending:
			if claw.global_position.distance_to(self.global_position) > max_range:
				claw.apply_impulse(Vector2(0,-250))
				set_arm_state(arm_state.retracting)
		arm_state.retracting:
			if claw.global_position.distance_to(self.global_position) < min_range:
				set_arm_state(arm_state.retracted)
	
func _input(event):
	if event.device != player_id:
		return
	
	match current_arm_state:
		arm_state.retracted:
			if event.is_action_pressed("TiltClockwise"):
				#print("Tilt")
				rotation += 0.1
			if event.is_action_pressed("TiltCounterclockwise"):
				print("Tilt")
				rotation -= 0.1
			
			if event.is_action_pressed("FireHand"):
				print("retracted")
				claw.apply_impulse(Vector2(0,150))
				set_arm_state(arm_state.extending)
