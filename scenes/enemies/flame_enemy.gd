extends CharacterBody2D

@export var SPEED = 42
const MAX_PIXELS_TO_MOVE = 25
const RECALCULATED_MAX_PIXELS_TO_MOVE = MAX_PIXELS_TO_MOVE - 0.01
# By defining the flame_type we can have as many behaviours as we want
@export var flame_type :int 
@export var endPoint: Marker2D
var animationDirection
var limitBeforeChangingDirection = 0.5
@export var MAX_HEALTH = 2
var currentHealth = 2
@onready var hitSound = $HitSound
# Definition of the behaviour types of this enemy 
enum{
	MOVE_FREELY,
	MOVE_TO_POINT
}
# State machine of the enemy's actions 
enum{
	IDLE,
	MOVE,
	NEW_DIRECTION
}
var startPosition
var endPosition
var direction = Vector2.RIGHT
var current_state = IDLE
var tween 

func _ready():
	startPosition = position 
	match flame_type:
		MOVE_TO_POINT: 
			endPosition = endPoint.global_position
		MOVE_FREELY: 
			$Timer.start()
			randomize()

# Swap end and start positions so it goes back and forth 
func changeDirection(): 
	var aux = endPosition
	endPosition = startPosition
	startPosition = aux 
	
func _process(delta): 
	match flame_type:
		MOVE_TO_POINT: 
			pass
		MOVE_FREELY: 
			match current_state:
				IDLE: 
					$AnimatedSprite2D.play("walk_down")
					pass
				NEW_DIRECTION: 
					direction = chooseRandomly([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
				MOVE:
					move(delta) 
#	check_if_player_is_in_hit_area()
	
func check_if_player_is_in_hit_area(): 
	for body in $EnemyHitBox.get_overlapping_bodies():
		if body.name == "player":
			body.enemyHit($EnemyHitBox)

func _physics_process(_delta):
	match flame_type:
		MOVE_TO_POINT: 
			updateVelocity()
			move_and_slide()
			updateAnimation()
		MOVE_FREELY: 
			pass
	
func move(delta):
	position += direction * SPEED * delta 
	redirectSprite()
	controlPositionNotOutOfBounds()
	
func updateAnimation(): 
	match flame_type:
		MOVE_TO_POINT: 
				animationDirection = "down"
				if velocity.y < 0: animationDirection = "up"
				$AnimatedSprite2D.play("walk_" + animationDirection)
		MOVE_FREELY: 
			pass 

func updateVelocity():
	var moveDirection = endPosition - position
	if moveDirection.length() < limitBeforeChangingDirection:
		changeDirection()
	velocity = moveDirection.normalized() * SPEED 
	
func chooseRandomly(array):
	array.shuffle()
	return array.front() 

func controlPositionNotOutOfBounds():
	if position.x >= startPosition.x + MAX_PIXELS_TO_MOVE:
		position.x = startPosition.x + RECALCULATED_MAX_PIXELS_TO_MOVE 
	if position.x <= startPosition.x - MAX_PIXELS_TO_MOVE:
		position.x = startPosition.x - RECALCULATED_MAX_PIXELS_TO_MOVE 
	if position.y >= startPosition.y + MAX_PIXELS_TO_MOVE :
		position.y = startPosition.y + RECALCULATED_MAX_PIXELS_TO_MOVE  
	if position.y <= startPosition.y - MAX_PIXELS_TO_MOVE:
		position.y = startPosition.y - RECALCULATED_MAX_PIXELS_TO_MOVE  

func _on_area_2d_body_entered(body):
	if flame_type != MOVE_TO_POINT:
		if body.name != "player" && current_state == MOVE: 
			direction = direction * -1
		elif body.name == "player":
			current_state = IDLE
			$AnimatedSprite2D.play("walk_down")

func redirectSprite():
	if direction.x == 1:
		$AnimatedSprite2D.flip_h = true
	elif direction.x == -1:
		$AnimatedSprite2D.flip_h = false

func _on_timer_timeout():
	$Timer.wait_time = chooseRandomly([0.5, 1, 2, 1.5, 3])
	current_state = chooseRandomly([NEW_DIRECTION, MOVE])
	
func hittedEnemy(): 
	tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property($AnimatedSprite2D,"scale",Vector2(1.5,1.5),0.1)
	tween.tween_property($AnimatedSprite2D,"scale",Vector2.ONE,0.1)
	tween.tween_property($AnimatedSprite2D,"modulate",Color(50,50,50),0.1)
	tween.tween_property($AnimatedSprite2D,"modulate",Color.WHITE,0.1)

func playerHit(): 
	$HitFx.emitting = true 
	currentHealth -= 1
	if currentHealth <= 0: 
		Global.enemies_in_first_area -= 1
		if Global.enemies_in_first_area <= 0:
			Global.first_area_completed.emit()
			print_debug("all enemies killed")
		death()
	else: hittedEnemy() 

func death():
	$EnemyHitBox/CollisionShape2D.set_deferred("disabled", true)
	tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(1.5,1.5), 0.2)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(self.queue_free)
