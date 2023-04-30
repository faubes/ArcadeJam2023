extends RigidBody2D
class_name Claw

@onready var animation_player = $AnimationPlayer
@onready var big_claw = $BigClaw
@onready var small_claw = $SmallClaw

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
	if body:
		print("Body {name} entered {this}".format({"name" : body.name, "this" : self.name}))
