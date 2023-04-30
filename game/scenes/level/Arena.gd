extends Node2D
class_name Arena

@onready var pickup_scene = preload("res://scenes/pickup/PickUp.tscn")
@onready var large_pickup_scene = preload("res://scenes/pickup/PickUpBasicPointsLarge.tscn")
@onready var animation_player = $AnimationPlayer
@onready var center : Vector2 = get_viewport_rect().size/2

func _ready():
	animation_player.play("level1")

func _on_spawn_PickUp():
	print("spawn")
	var pickup : PickUp = pickup_scene.instantiate()
	pickup.position = center + +350 * Vector2(randf(), randf())
	add_child(pickup)

func _on_spawn_Large_PickUp():
	print("spawn Large")
	#var pickup = large_pickup_scene.instantiate()
	#pickup.position = center + +350 * Vector2(randf(), randf())
	#add_child(pickup)

func _on_spawn_num_PickUp(num : int):
	print("spawn")
	for i in range(num):
		var pickup = pickup_scene.instantiate()
		pickup.position = center + +350 * Vector2(randf(), randf())
		add_child(pickup)
