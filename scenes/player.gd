extends CharacterBody2D

var speed: int = 55
var animationDirection

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed 

# Note that this configureCameraLimits() func has to be in the _ready() func since this will be 
# called each time a new scene is instantiated so it can reconfigure itself depending on the scene.
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
		animationDirection = "down"
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


func _on_doggy_pet_dog():
	set_physics_process(false)
	$Timer.start()
	if get_parent().get_node("Doggy").position.x >= position.x: 
		$AnimationPlayer.play("pet_doggy_right")
	else: 
		$AnimationPlayer.play("pet_doggy_left")


func _on_timer_timeout():
	set_physics_process(true)
