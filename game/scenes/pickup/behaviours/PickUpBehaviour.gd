extends Node
class_name PickUpBehaviour

func perform(player : Player, pickUp : PickUp):
	print("Error: No 'consume' behaviour %s." % pickUp.name)
