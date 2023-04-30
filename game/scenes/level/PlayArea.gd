extends Node2D
class_name PlayArea

@export var aspectRatio : float = 0.0
@export var cornerOffset = Vector2(0.0, 0.0)

@export_node_path("Node2D") var playerTopLeft = null
@export_node_path("Node2D") var playerTopRight = null
@export_node_path("Node2D") var playerBottomLeft = null
@export_node_path("Node2D") var playerBottomRight = null

@export_node_path("CollisionShape2D") var leftWall = null
@export_node_path("CollisionShape2D") var rightWall = null
@export_node_path("CollisionShape2D") var topWall = null
@export_node_path("CollisionShape2D") var bottomWall = null

@export_node_path("NinePatchRect") var letterboxA = null
@export_node_path("NinePatchRect") var letterboxB = null

var areaRect : Rect2 = Rect2(0.0, 0.0, 0.0, 0.0)

# Called when the node enters the scene tree for the first time.
func _ready():
	initPlayAreaRect()
	placePlayers()
	placeWalls()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	placeWalls()

func _draw():
	draw_rect(areaRect, Color.CRIMSON, false, 1.0)

func get_rect():
	return areaRect

func get_center():
	return areaRect.position + areaRect.size * 0.5

func get_width():
	return areaRect.size.x

func get_height():
	return areaRect.size.y

func get_inner_radius():
	return min(areaRect.size.x, areaRect.size.y) * 0.5

func initPlayAreaRect():
	var viewportPosition = get_viewport_rect().position
	var viewportSize = get_viewport_rect().size
	var viewportAspect = viewportSize.x / viewportSize.y
	
	var lbA = get_node(letterboxA) as NinePatchRect
	var lbB = get_node(letterboxB) as NinePatchRect
	
	lbA.visible = true
	lbB.visible = true
	
	if (aspectRatio <= 0.0):
		areaRect = Rect2(get_viewport_rect())
		lbA.visible = false
		lbB.visible = false
	
	elif (aspectRatio >= viewportAspect):
		# Fit the width of the viewport + center vertically.
		var areaWidth = viewportSize.x
		var areaHeight = areaWidth / aspectRatio
		if (areaHeight > viewportSize.y):
			var downscale = viewportSize.y / areaHeight
			areaHeight *= downscale
			areaWidth *= downscale
		
		var emptyHeight = (viewportSize.y - areaHeight) * 0.5
		areaRect = Rect2(viewportPosition.x, emptyHeight, areaWidth, areaHeight)
		
		lbA.position = Vector2.ZERO
		lbA.size = Vector2(viewportSize.x, emptyHeight)
		
		lbB.position = Vector2(0.0, areaRect.position.y + areaRect.size.y)
		lbB.size = Vector2(viewportSize.x, emptyHeight)

	elif (aspectRatio < viewportAspect):
		# Fit the height of the viewport + center horizontally.
		var areaHeight = viewportSize.y
		var areaWidth = areaHeight * aspectRatio
		if (areaWidth > viewportSize.x):
			var downscale = viewportSize.x / areaWidth
			areaHeight *= downscale
			areaWidth *= downscale
		
		var emptyWidth = (viewportSize.x - areaWidth) * 0.5
		areaRect = Rect2(emptyWidth, viewportPosition.y, areaWidth, areaHeight)
		
		lbA.position = Vector2.ZERO
		lbA.size = Vector2(emptyWidth, viewportSize.y)
		
		lbB.position = Vector2(areaRect.position.x + areaRect.size.x, 0.0)
		lbB.size = Vector2(emptyWidth, viewportSize.y)

func placePlayers():
	if (playerTopLeft != null):
		var p = get_node(playerTopLeft)
		p.global_position = areaRect.position + Vector2(cornerOffset.x, cornerOffset.y)

	if (playerTopRight != null):
		var p = get_node(playerTopRight)
		p.global_position = Vector2(areaRect.end.x, areaRect.position.y) + Vector2(-cornerOffset.x, cornerOffset.y)

	if (playerBottomLeft != null):
		var p = get_node(playerBottomLeft)
		p.global_position = Vector2(areaRect.position.x, areaRect.end.y) + Vector2(cornerOffset.x, -cornerOffset.y)

	if (playerBottomRight != null):
		var p = get_node(playerBottomRight)
		p.global_position = areaRect.end + Vector2(-cornerOffset.x, -cornerOffset.y)

func placeWalls():
	var wallThickness = 50 
	var center = areaRect.position + areaRect.size * 0.5
	if (leftWall != null):
		var w = get_node(leftWall) as CollisionShape2D
		w.global_position = Vector2(areaRect.position.x - wallThickness * 0.5, center.y)
		(w.shape as RectangleShape2D).size = Vector2(wallThickness, areaRect.size.y + wallThickness * 2.0)
	
	if (rightWall != null):
		var w = get_node(rightWall) as CollisionShape2D
		w.global_position = Vector2(areaRect.position.x + areaRect.size.x + wallThickness * 0.5, center.y)
		(w.shape as RectangleShape2D).size = Vector2(wallThickness, areaRect.size.y + wallThickness * 2.0)
		
	if (topWall != null):
		var w = get_node(topWall) as CollisionShape2D
		w.global_position = Vector2(center.x, areaRect.position.y - wallThickness * 0.5)
		(w.shape as RectangleShape2D).size = Vector2(areaRect.size.x, wallThickness)
	
	if (bottomWall != null):
		var w = get_node(bottomWall) as CollisionShape2D
		w.global_position = Vector2(center.x, areaRect.position.y + areaRect.size.y + wallThickness * 0.5)
		(w.shape as RectangleShape2D).size = Vector2(areaRect.size.x, wallThickness)

