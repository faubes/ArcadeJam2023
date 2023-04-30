extends PickUpBehaviour
class_name PickUpAwardPointsBehaviour

func perform(pickUp : PickUp, player : Player):
	print("Award %d points!" %pickUp.pointValue)
	GameCore.add_player_score(player.player_id, pickUp.pointValue)
