extends PickUpBehaviour
class_name PickUpAwardPointsBehaviour

func perform(player : Player, pickUp : PickUp):
	print("Award %d points!" %pickUp.pointValue)
	GameCore.add_player_score(player.player_id, pickUp.pointValue)
