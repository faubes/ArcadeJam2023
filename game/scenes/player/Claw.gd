extends RigidBody2D
class_name Claw

@onready var animation_player = $AnimationPlayer
@onready var big_claw = $BigClaw
@onready var small_claw = $SmallClaw
@onready var grab_area_shape = $GrabArea/GrabAreaShape


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
		
func _on_grab_area_body_entered(body):
	if body == self:
		return
	var pickup = body as PickUp
	if pickup:
		print("Body {name} consumed by {this}".format({"name" : body.name, "this" : self.name}))
		pickup._on_consumed(self)
	if body:
		print("Body {name} entered {this}".format({"name" : body.name, "this" : self.name}))