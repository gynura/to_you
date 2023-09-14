extends CharacterBody2D

const MAX_HEALTH = 12

# This could even come from the enemy's node so each enemy could define its own knockback
@export var knockbackPower: int = 500
var speed = 55
var animationDirection = "down"
var currentHealth: int = 12 
var isHurt: bool = false 
var enemyCollisions = []
var blockMovement: bool = false 
var canAttack: bool = true 
var tween 
var tween2 # TODO study a better way to paralelize tweens 
@export var has_weapon: bool = false 
var is_attacking: bool = false 

signal health_change 
signal attack_position_changed(position)
signal attack
signal end_attack
signal hurt_enemy
signal player_heal 

# Note that this configureCameraLimits() func has to be in the _ready() func since this will be 
# called each time a new scene is instantiated so it can reconfigure itself depending on the scene.
func _ready():
	DialogManager.dialog_ended.connect(_restart_process)
	DialogManager.stop_player.connect(_stop_player)
	DialogManager.read_sign_stop.connect(_restart_process)
	DialogManager.read_sign_start.connect(_stop_player)
	Global.transition_to_scene.connect(_stop_player)
	Global.entered_new_scene.connect(_restart_process)
	Global.restart_player.connect(_restart_process)
	Global.game_completed.connect(_killed_boss)
	configureCameraLimits() 
	has_weapon = Global.player_got_weapon
	Global.player_heal.connect(_health_up)

func _physics_process(delta):
	if Global.begin_game:
		return 
	if blockMovement: 
		return 
	handleInput()
	move_and_slide()
	updateAnimation()
	if !isHurt:
		for enemy in enemyCollisions:
			enemyHit(enemy)
			
func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = moveDirection * speed 
	if !canAttack || !has_weapon:
			return 
	if Input.is_action_pressed("attack_button"):
		# Signal that sends the position to aim the weapon' sprite
		canAttack = false 
		emit_signal("attack")
		$ShowWeaponSound.play()
		$AnimationPlayer.play("attack_" + animationDirection)
		blockMovement = true 

func updateAnimation(): 
	if blockMovement:
		return
	if velocity.length() == 0:
		$AnimationPlayer.play("iddle")
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
	$ActionTimer.start()
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
	
func _stop_player():
	$AnimationPlayer.play("iddle")
	set_physics_process(false)

func _restart_process(): 
	hide_dialog_marker()
	set_physics_process(true)
	
func _health_up():
	if currentHealth < Global.PLAYER_MAX_HEALTH:
		if currentHealth + 2 <= Global.PLAYER_MAX_HEALTH:
			currentHealth += 2 
			Global.player_current_health += 2
		else:
			currentHealth += 1 
			Global.player_current_health += 1
		player_heal.emit()

func enemyHit(enemyArea):
	$ShowWeaponSound.stop()
	# Because of the processing, we need to check if the appended enemyArea's enemy is still alive
	# if not it won't damage the player
	if enemyArea.owner.currentHealth <= 0:
		return
	currentHealth -= 1
	Global.player_current_health -= 1
	enemyArea.owner.hitSound.play()
	# REMOVE LATER 
	if currentHealth <= 0:
		currentHealth = MAX_HEALTH
	health_change.emit()
	isHurt = true 
	knockback(enemyArea.get_parent().get_velocity())
	playHurtAnimation()
	$HurtTimer.start()
	
func playHurtAnimation(): 
	tween = create_tween()
	tween2 = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween2.set_ease(tween.EASE_OUT)
	tween2.set_trans(Tween.TRANS_CIRC)
	tween.tween_property($Sprite2D,"scale",Vector2(1.2,1.2),0.2)
	tween.tween_property($Sprite2D,"scale",Vector2.ONE,0.2)
	tween2.tween_property($Sprite2D,"modulate",Color.RED,0.2)
	tween2.tween_property($Sprite2D,"modulate",Color.WHITE,0.2)

func _on_hurt_box_area_entered(area):
	if area.name == "EnemyHitBox" && !isHurt: 
		enemyCollisions.append(area)

func _on_action_animations_timeout():
	set_physics_process(true)

func _on_hurt_timer_timeout():
	isHurt = false 

func _on_hurt_box_area_exited(area):
	enemyCollisions.erase(area)

func _on_weapon_attack_end():
	blockMovement = false 

func _on_weapon_next_attack():
	canAttack = true

func _on_weapon_enemy_hit():
	$ShowWeaponSound.stop()
	emit_signal("hurt_enemy")

func _on_froggy_give_weapon_to_player():
	set_physics_process(false)
	_show_gotten_item()
	$ActionTimer.start()
	$AnimationPlayer.play("get_item")
	has_weapon = true 
	Global.player_got_weapon = true 
	
func show_dialog_marker():
	$DialogMarker.visible = true
	
func hide_dialog_marker():
	$DialogMarker.visible = false 
	
func _show_gotten_item():
	$GetWeaponSprite.visible = true 
	$GetItemSound.play()
	var tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property($GetWeaponSprite, "scale", Vector2(1.5,1.5), 0.9)
	tween.tween_property($GetWeaponSprite, "scale", Vector2.ZERO, 0.2)
	tween.tween_property($GetWeaponSprite, "visible", false, 0.1)
	
func _killed_boss():
	_stop_player()
	$AnimationPlayer.play("killed_boss")
	$Expressions.visible = true
	$Expressions.play("victory")


func _on_boss_fight_start_boss_fight():
	$Expressions.visible = true
	$Expressions.play("bonk")
	_stop_player()


func _on_final_boss_start_fight():
	$Expressions.visible = false
	$Expressions.stop()
	_restart_process()
