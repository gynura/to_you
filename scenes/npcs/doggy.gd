extends CharacterBody2D

@export var player: CharacterBody2D

# States of the state-machine 
enum{
	IDLE,
	MOVE,
	NEW_DIRECTION
}
signal pet_dog
const SPEED = 30.0
const MAX_PIXELS_TO_MOVE = 25
const RECALCULATED_MAX_PIXELS_TO_MOVE = MAX_PIXELS_TO_MOVE - 0.01
var current_state = IDLE
var direction = Vector2.RIGHT
# With this variable we can control that it never goes out of bounds when randomly moving 
var start_position 
var canInteract = false 

func _ready():
	start_position = position
	randomize()  
	
func _physics_process(delta):
	if Input.is_action_just_pressed("interact_button"):
		if canInteract:
			petTheDoggy()

func _process(delta): 
	match current_state:
		IDLE: 
			$AnimatedSprite2D.play("idle")
			pass
		NEW_DIRECTION: 
			$AnimatedSprite2D.play("idle")
			direction = chooseRandomly([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		MOVE: 
			$AnimatedSprite2D.play("walk")
			move(delta)

func move(delta):
	position += direction * SPEED * delta 
	redirectSprite()
	controlPositionNotOutOfBounds()

func chooseRandomly(array):
	array.shuffle()
	return array.front() 

func _on_timer_timeout():
	$Timer.wait_time = chooseRandomly([0.5, 1, 2, 1.5, 3])
	current_state = chooseRandomly([IDLE, NEW_DIRECTION, MOVE])
	
func redirectSprite():
	if direction.x == 1:
		$AnimatedSprite2D.flip_h = false
		$Shadow.flip_h = false
	elif direction.x == -1:
		$AnimatedSprite2D.flip_h = true
		$Shadow.flip_h = true
	
func controlPositionNotOutOfBounds():
	if position.x >= start_position.x + MAX_PIXELS_TO_MOVE:
		position.x = start_position.x + RECALCULATED_MAX_PIXELS_TO_MOVE 
	if position.x <= start_position.x - MAX_PIXELS_TO_MOVE:
		position.x = start_position.x - RECALCULATED_MAX_PIXELS_TO_MOVE 
	if position.y >= start_position.y + MAX_PIXELS_TO_MOVE :
		position.y = start_position.y + RECALCULATED_MAX_PIXELS_TO_MOVE  
	if position.y <= start_position.y - MAX_PIXELS_TO_MOVE:
		position.y = start_position.y - RECALCULATED_MAX_PIXELS_TO_MOVE  

func _on_area_2d_body_entered(body):
	if body.name == "player": 
		if $Heart.visible == false: 
			$Bubble.visible = true
			$Bubble.play("default")
			canInteract = true 
	elif current_state == MOVE: 
		direction = direction * -1

func petTheDoggy():
	set_process(false)
	$AnimatedSprite2D.play("idle")
	pet_dog.emit()
	controlHeartParticle()

func controlHeartParticle():
	if $HeartTimer.is_stopped():
			$Bubble.stop()
			$Bubble.visible = false 
			$Heart.visible = true
			$HeartTimer.start()

func _on_heart_timer_timeout():
	set_process(true)
	$Heart.visible = false

func _on_area_2d_body_exited(body):
	if body.name == "player": 
		$Bubble.stop()
		$Bubble.visible = false 
		canInteract = false 
