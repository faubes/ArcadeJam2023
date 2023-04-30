extends RigidBody2D
class_name Claw

@onready var animation_player = $AnimationPlayer
@onready var big_claw = $BigClaw
@onready var small_claw = $SmallClaw
@onready var grab_area_shape = $GrabArea/GrabAreaShape


var player_owner : Player
var is_closing : bool = false


func set_player(new_player : Player):
	player_owner = new_player

func set_color(new_color):
	big_claw.color = new_color
	small_claw.color = new_color

func _ready():
	animation_player.play_backwards("open")

func open() -> void : 
	if animation_player:
		animation_player.play("open")

func close() -> void : 
	if animation_player:
		animation_player.play_backwards("open")
		#print("closing")
		is_closing = true
		
func _on_grab_area_body_entered(body):
	if body == self:
		return
	if not is_closing:
		return
	# only consume pickups if claw is closing
	var pickup = body as PickUp
	if pickup:
		print("Body {name} consumed by {this}".format({"name" : body.name, "this" : self.name}))
		pickup._on_consumed(self)
	if body:
		print("Body {name} entered {this}".format({"name" : body.name, "this" : self.name}))


func recoil():
	open()
	player_owner.recoil()

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
