extends CharacterBody2D

@export var speed: int = 45
@onready var animations = $AnimationPlayer

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed 
	
func _physics_process(delta):
	handleInput()
	move_and_slide()
	updateAnimation()

func updateAnimation(): 
	if velocity.length() == 0:
		animations.play("iddle")
	else: 
		var animationDirection = "down"
		if velocity.x < 0: animationDirection = "left"
		elif velocity.x > 0: animationDirection = "right"
		elif velocity.y < 0: animationDirection = "up"
		
		animations.play("walk_" + animationDirection)
