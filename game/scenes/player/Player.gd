extends StaticBody2D
class_name Player

@onready var groove_joint_2d : GrooveJoint2D = $GrooveJoint2D
@onready var claw : Claw = $GrooveJoint2D/Claw

@export var min_range : float = 100
@export var speed : float = 500
@export var retract_speed : float = 1000

@export var player_id : int = 0
@export var player_color : Color
@export var phase_angle : float

enum hand_state { closed, open }
enum arm_state { retracted, extending, retracting }


var current_hand_state : hand_state = hand_state.closed
var current_arm_state : arm_state = arm_state.retracted

var switch_rotation : bool = false
var current_rotation_input : float = 0
var target_angle : float
var player_flip_sign = 1

var debug : bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	claw.set_color(player_color)
	claw.set_player(self)
	#claw.global_position = self.global_position + min_range * Vector2.RIGHT
	if debug:
		print("{player} start angle: {angle} end angle: {end_angle}" \
			.format({"player" : player_id, "angle" : phase_angle, "end_angle" : phase_angle + PI/2}))
	target_angle = phase_angle + PI/4
	rotation = target_angle

func set_hand_state(new_state : hand_state):
	if current_hand_state == new_state:
		return
	if debug:
		print("{old} -> {new}".format({"old" : current_hand_state, "new" : new_state}))
	current_hand_state = new_state

func set_arm_state(new_state : arm_state):
	if current_arm_state == new_state:
		return
	if debug:
		print("{old} -> {new}".format({"old" : current_arm_state, "new" : new_state}))
	current_arm_state = new_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	match current_arm_state:
		arm_state.retracted:
			if claw.global_position.distance_to(self.global_position) > min_range * 1.1:
				set_arm_state(arm_state.retracting)
			else:
				claw.linear_velocity = Vector2.ZERO
		arm_state.extending:
			if claw.global_position.distance_to(self.global_position) > groove_joint_2d.length * 0.9:
				claw.linear_velocity = Vector2.ZERO
				set_arm_state(arm_state.retracting)
			elif claw.linear_velocity.length() < 1 and claw.global_position.distance_to(self.global_position) > groove_joint_2d.length * 0.2:
				set_arm_state(arm_state.retracting)
			else:
				claw.apply_force(speed  * transform.basis_xform(Vector2.DOWN))
		arm_state.retracting:
			if claw.global_position.distance_to(self.global_position) < min_range:
				set_arm_state(arm_state.retracted)
				claw.linear_velocity = Vector2.ZERO
				if claw.is_holding_pickup():
					claw.consume_pickup()
			else:
				claw.apply_force(-retract_speed * transform.basis_xform(Vector2.DOWN))

	if switch_rotation:
		var remap_angle = (current_rotation_input + 1) / 2
		target_angle = lerp_angle(phase_angle, phase_angle + PI/2,  remap_angle)
		switch_rotation = false
	
	if (not is_equal_approx(rotation, target_angle)):
		rotation = move_toward(rotation, target_angle, delta)



func _input(event):
	if !GameCore.inGame and !debug:
		return
	
	if event.device != player_id:
		return
	
	match current_hand_state:
		hand_state.open:
			if event.is_action_pressed("ReelIn"):
				claw.close()
				current_hand_state = hand_state.closed
		hand_state.closed:
			if event.is_action_pressed("ReelIn"):
				claw.open()
				current_hand_state = hand_state.open

		
	match current_arm_state:
		arm_state.retracted:
			if event.is_action_pressed("FireHand"):
				claw.linear_velocity = Vector2.ZERO
				set_arm_state(arm_state.extending)
				target_angle = rotation # stop rotating
			if event.is_action_pressed("TiltClockwise"):
				switch_rotation = true
				current_rotation_input = 1 * player_flip_sign
			if event.is_action_pressed("TiltCounterclockwise"):
				switch_rotation = true
				current_rotation_input = -1 * player_flip_sign


func recoil():
	if current_arm_state == arm_state.extending or current_arm_state == arm_state.retracting:
		claw.apply_impulse(-0.3 * retract_speed * transform.basis_xform(Vector2.DOWN))
		set_hand_state(hand_state.open)
		set_arm_state(arm_state.retracting)
