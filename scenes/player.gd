extends CharacterBody2D

@export var speed: int = 45

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed 
	
func _ready():
	configureCameraLimits() 
	pass 

func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()

func updateAnimation(): 
	if velocity.length() == 0:
		$AnimationPlayer.play("iddle")
	else: 
		var animationDirection = "down"
		if velocity.x < 0: animationDirection = "left"
		elif velocity.x > 0: animationDirection = "right"
		elif velocity.y < 0: animationDirection = "up"
		$AnimationPlayer.play("walk_" + animationDirection)
		
func configureCameraLimits(): 
	var tilemap = get_parent().get_node("TileMap")
	# Each tile on the scene defines a rectangle which I'll use to define the limits of the camera.
	# By having this rectangle, I can control the camera so it doesn't go out of bounds.
	var tilemap_rect = tilemap.get_used_rect() 
	var tilemap_cell_size = tilemap.tile_set.tile_size
	# Because Camera2D limits are set in pixels not tiles, we need to convert them to pixels
	$Camera2D.limit_left = tilemap_rect.position.x * tilemap_cell_size.x 
	$Camera2D.limit_right = tilemap_rect.end.x * tilemap_cell_size.x
	$Camera2D.limit_top = tilemap_rect.position.y * tilemap_cell_size.y
	$Camera2D.limit_bottom = tilemap_rect.end.y * tilemap_cell_size.y
