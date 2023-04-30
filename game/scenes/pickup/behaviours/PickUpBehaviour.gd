extends Node
class_name PickUpBehaviour

func perform(pickUp : PickUp, _player : Player):
	print("Error: No 'consume' behaviour %s." % pickUp.name)
