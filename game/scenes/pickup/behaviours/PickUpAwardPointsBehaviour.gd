extends PickUpBehaviour
class_name PickUpAwardPointsBehaviour

	
func perform(pickUp : PickUp):
	print("Award %d points!" %pickUp.pointValue)
