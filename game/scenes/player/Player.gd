extends StaticBody2D

@onready var groove_joint_2d = $GrooveJoint2D
@onready var claw = $GrooveJoint2D/Claw

@export var min_range = 100
@export var speed = 500
@export var retract_speed = 1000

@export var player_id : int = 0
enum hand_state { closed, open }
enum arm_state { retracted, extending, retracting }

var phase_angle : float = player_id * PI/2

var current_hand_state : hand_state = hand_state.closed
var current_arm_state : arm_state = arm_state.retracted

# Called when the node enters the scene tree for the first time.
func _ready():
	claw.global_position = self.global_position + min_range * Vector2.RIGHT
	rotation = phase_angle

func set_arm_state(new_state : arm_state):
	if current_arm_state == new_state:
		return
	print("{old} -> {new}".format({"old" : current_arm_state, "new" : new_state}))
	current_arm_state = new_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match current_arm_state:
		arm_state.extending:
			if claw.global_position.distance_to(self.global_position) > groove_joint_2d.length * 0.9:
				claw.linear_velocity = Vector2.ZERO
				claw.apply_impulse(retract_speed * transform.basis_xform(Vector2.DOWN))
				set_arm_state(arm_state.retracting)
		arm_state.retracting:
			if claw.global_position.distance_to(self.global_position) < min_range:
				set_arm_state(arm_state.retracted)
				claw.linear_velocity = Vector2.ZERO
				
	
func _input(event):
	if event.device != player_id:
		return
	
	match current_arm_state:
		arm_state.retracted:
			if event.is_action_pressed("TiltClockwise"):
				var new_rotation = clampf(rotation + 0.1, phase_angle, phase_angle + PI/2)
				rotation = new_rotation
			if event.is_action_pressed("TiltCounterclockwise"):
				var new_rotation = clampf(rotation - 0.1, phase_angle, phase_angle + PI/2)
				rotation = new_rotation
			
			if event.is_action_pressed("FireHand"):
				print("retracted")
				claw.linear_velocity = Vector2.ZERO
				claw.apply_impulse(speed  * transform.basis_xform(Vector2.DOWN))
				set_arm_state(arm_state.extending)
