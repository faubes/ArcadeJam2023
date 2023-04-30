extends RigidBody2D
class_name Claw

@onready var animation_player = $AnimationPlayer
@onready var big_claw = $BigClaw
@onready var small_claw = $SmallClaw
@onready var grab_area_shape = $GrabArea/GrabAreaShape


var player_owner : Player
var is_closing : bool = false
var held_pickup : Array[PickUp]
var debug : bool = false

func set_player(new_player : Player):
	player_owner = new_player

func set_color(new_color):
	big_claw.color = new_color
	small_claw.color = new_color

func _ready():
	animation_player.play_backwards("open")

func open() -> void : 
	if animation_player:
		if is_holding_pickup():
			drop_pickup()
		animation_player.play("open")

func close() -> void : 
	if animation_player:
		animation_player.play_backwards("open")
		#print("closing")
		is_closing = true

func is_holding_pickup():
	return not held_pickup.is_empty()

func consume_pickup():
	print("Consume!")
	for item in held_pickup:
		item.consume(player_owner)
	held_pickup = []
	
func grab_pickup(new_pickup : PickUp):
	new_pickup.grab(player_owner)
	if new_pickup.destroyOnGrab:
		return
	held_pickup.append(new_pickup)
	new_pickup.position = Vector2.ZERO
	
func drop_pickup():
	if held_pickup.is_empty():
		print("Unexpected: drop pickup without pickup?")
		return
	for item in held_pickup:
		item.release()
	held_pickup = []


func recoil():
	open()
	if held_pickup:
		drop_pickup()
	player_owner.recoil()

func _on_grab_area_body_entered(body):
	if body == self:
		return
	# only consume pickups if claw is closing
	if not is_closing:
		return
	var pickup = body as PickUp
	if pickup:
		grab_pickup(pickup)



func _on_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	if body_rid == self.get_rid():
		return
	var other_claw = body as Claw
	if other_claw:
		recoil()
		other_claw.recoil()
		return

func _on_open_start():
	if is_closing:
		#print("done closing")
		is_closing = false


func _physics_process(_delta):
	if debug and player_owner.player_id == 0 and is_holding_pickup():
		print(self.position)
	for item in held_pickup:
		item.global_position = self.global_position
