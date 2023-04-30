extends Node2D
class_name Arena

@onready var pickup_scene = preload("res://scenes/pickup/PickUp.tscn")
@onready var animation_player = $AnimationPlayer

@onready var center : Vector2 = get_viewport_rect().size/2

func _ready():
	animation_player.play("level1")

func _on_spawn_PickUp():
	print("spawn")
	var pickup = pickup_scene.instantiate()
	pickup.position = center + +50 * Vector2(randf(), randf())
	add_child(pickup)

func _on_spawn_num_PickUp(num : int):
	print("spawn")
	for i in range(num):
		var pickup = pickup_scene.instantiate()
		pickup.position = center + +50 * Vector2(randf(), randf())
		add_child(pickup)
