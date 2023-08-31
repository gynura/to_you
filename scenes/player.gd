extends CharacterBody2D

const MAX_HEALTH = 12

var speed = 55
var animationDirection = "down"
var currentHealth: int = 12 
# This could even come from the enemy's node so each enemy could define its own knockback
@export var knockbackPower: int = 500
var isHurt: bool = false 
var enemyCollisions = []
var blockMovement: bool = false 
var canAttack: bool = true 

signal health_change 
signal attack_position_changed(position)
signal attack
signal end_attack
signal hurt_enemy

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed 
	if !canAttack:
			return 
	if Input.is_action_pressed("attack_button"):
		# Signal that sends the position to aim the weapon' sprite
		canAttack = false 
		emit_signal("attack")
		$AnimationPlayer.play("attack_" + animationDirection)
		blockMovement = true 

# Note that this configureCameraLimits() func has to be in the _ready() func since this will be 
# called each time a new scene is instantiated so it can reconfigure itself depending on the scene.
func _ready():
	configureCameraLimits() 

func _physics_process(delta):
	if blockMovement: 
		return 
	handleInput()
	move_and_slide()
	updateAnimation()
	if !isHurt:
		for enemy in enemyCollisions:
			enemyHit(enemy)

func updateAnimation(): 
	if blockMovement:
		return
	if velocity.length() == 0:
		$AnimationPlayer.play("iddle")
		animationDirection = "down"
		emit_signal("attack_position_changed", animationDirection)
	else: 
		animationDirection = "down"
		if velocity.x < 0: animationDirection = "left"
		elif velocity.x > 0: animationDirection = "right"
		elif velocity.y < 0: animationDirection = "up"
		$AnimationPlayer.play("walk_" + animationDirection)
		emit_signal("attack_position_changed", animationDirection)
		
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
	$ActionAnimations.start()
	if get_parent().get_node("Doggy").position.x >= position.x: 
		$AnimationPlayer.play("pet_doggy_right")
	else: 
		$AnimationPlayer.play("pet_doggy_left")
		
func knockback(enemyVelocity: Vector2): 
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()
	
func endInvincibility():
	isHurt = false 

func enemyHit(enemy):
	currentHealth -= 1
	# REMOVE LATER 
	if currentHealth <= 0:
		currentHealth = MAX_HEALTH
	health_change.emit()
	isHurt = true 
	knockback(enemy.get_parent().get_velocity())
	$EffectsAnimation.play("hurt_blink")
	$HurtTimer.start()

func _on_hurt_box_area_entered(area):
	if area.name == "EnemyHitBox": 
		enemyCollisions.append(area)

func _on_action_animations_timeout():
	set_physics_process(true)

func _on_hurt_timer_timeout():
	$EffectsAnimation.play("RESET")
	isHurt = false 

func _on_hurt_box_area_exited(area):
	enemyCollisions.erase(area)

func _on_weapon_attack_end():
	blockMovement = false 

func _on_weapon_hit_enemy():
	emit_signal("hurt_enemy")

func _on_weapon_next_attack():
	canAttack = true 
