extends CharacterBody2D

const MAX_HEALTH = 8
const MAX_FACE_NUMBER = 3
const SPEED = 50

@export var end_point: Marker2D
@onready var bullet_scene = preload("res://scenes/enemies/fire_bullet.tscn")
@onready var hitSound = $HitSound
var currentHealth = 8
var can_be_hurt :bool = true 
var spawn_bullets :bool = true 
var rotation_spawn = 0.3 
var limitBeforeChangingDirection = 0.5
@onready var shoot_bullets_timer_wait_time = $TimeBetweenEachBullet.wait_time
@onready var player = get_parent().get_node("player")
@export var can_shoot :bool = false 
var tween
var start_boss_fight :bool = false 
var face_number = 1
var start_position
var end_position
var can_move :bool = false 
var is_dead :bool = false 
var boss_fight_started :bool = false 

signal start_fight

func _ready():
	start_position = position 
	end_position = end_point.global_position
	randomize()

func _physics_process(_delta):
	if !is_dead:
		if can_move:
			_update_velocity()
			move_and_slide()

func _change_rotation_direction():
	rotation_spawn = rotation_spawn * -1
	
func _update_velocity():
	var moveDirection = end_position - position
	if moveDirection.length() < limitBeforeChangingDirection:
		_change_direction()
	velocity = moveDirection.normalized() * SPEED 

# Swap end and start positions so it goes back and forth 
func _change_direction(): 
	var aux = end_position
	end_position = start_position
	start_position = aux 

func _spawn_bullets():
	if !is_dead:
		if can_shoot: 
			if spawn_bullets:
				$BulletSpawner.rotate(rotation_spawn)
				var bullet = bullet_scene.instantiate()
				bullet.position = self.position
				bullet.rotation = $BulletSpawner.rotation
				get_parent().add_child(bullet, false, 1)
	
func _hit_final_boss():
	# Just a hacky way to chain animation between hits x) 
	if currentHealth % 2 == 0:
		$AnimatedSprite2D.play("hit1")
	else: 
		$AnimatedSprite2D.play("hit2")
	
func playerHit(): 
	if can_be_hurt: 
		currentHealth -= 1
		can_be_hurt = false 
		if currentHealth <= 0: 
			death()
		else: _hit_final_boss() 
		$InvincibilityTimer.start()
	
func death():
	is_dead = true  
	Global.killed_flame_boss.emit()
	$DeathSound.play()
	$TimeTillDeath.start()
	$EnemyHitBox/CollisionShape2D.set_deferred("disabled", true)

func _on_invincibility_timer_timeout():
	can_be_hurt = true 
	$AnimatedSprite2D.play("iddle_" + str(face_number))

func _on_boss_fight_start_boss_fight():
	start_boss_fight = true
	$LaughSound.play()
	$AnimatedSprite2D.play("iddle_3")
	$TimeBetweenEachBullet.start()
	$ChangeTimer.start()
	$TimeTillBossFight.start()

func _on_time_between_each_bullet_timeout():
	if can_shoot:
		_spawn_bullets()

func _on_time_between_bullet_spawns_timeout():
	if boss_fight_started: 
		can_shoot = !can_shoot  

func _on_change_timer_timeout():
	if boss_fight_started: 
		if can_be_hurt: 
			face_number = int(randf_range(0, 3)) + 1
			$AnimatedSprite2D.play("iddle_" + str(face_number))
		can_move = !can_move 

func _on_time_till_death_timeout():
	tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(1.5,1.5), 0.2)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2.ZERO, 0.2)

func _on_death_sound_finished():
	Global.game_completed.emit()
	queue_free()

func _on_time_till_boss_fight_timeout():
		boss_fight_started = true 
		can_shoot = true 
		start_fight.emit()
		$AnimatedSprite2D.play("iddle_2")
