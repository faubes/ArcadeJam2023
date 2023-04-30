extends Node2D

@onready var a = $A
@onready var b = $B
@onready var icon = $A/Icon

@onready var parent = a

func _on_timer_timeout():
	if parent == a:
		icon.call_deferred("reparent", b, false)
		parent = b
	else:
		icon.call_deferred("reparent", a, false)
		parent = a
