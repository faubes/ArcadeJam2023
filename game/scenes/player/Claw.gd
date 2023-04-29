extends RigidBody2D
class_name Claw

@onready var animation_player = $AnimationPlayer


var target : Vector2 = Vector2.RIGHT

func _ready():
	animation_player.play_backwards("open")

func _process(delta):
	#look_at(target)
	pass

func open() -> void : 
	if animation_player:
		animation_player.play("open")

func close() -> void : 
	if animation_player:
		animation_player.play_backwards("open")
		
