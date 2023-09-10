extends CharacterBody2D

const MAX_HEALTH = 8

@export var speed = 42
@onready var bullet_scene = preload("res://scenes/enemies/fire_bullet.tscn")
@onready var hitSound = $HitSound
var currentHealth = 8
var can_be_hurt :bool = true 
var spawn_bullets :bool = true 
var rotation_spawn = 0.3 
var rotation_timer = 0.1
var special_attack :bool = false 
@onready var shoot_bullets_timer_wait_time = $ShootBulletsTimer.wait_time
@onready var player = get_parent().get_node("player")
# TODO REMOVE THIS, ONLY USED TO TEST 
@export var can_shoot :bool = true 
var tween
var movement_mode = 1 
var attack_mode = 1 

func _process(delta):
	if special_attack: 
		_cast_special_attack()

func _change_rotation():
	if currentHealth <= 3:
		if randi() % 2:
			_cast_special_attack()
	
	rotation_spawn = randf_range(0.1,0.3) 
	rotation_timer = randf_range(1,2) 
		
	if randi() % 2:
		_change_rotation_direction()
	
	$BulletSprayTimer.wait_time = rotation_timer

func _change_rotation_direction():
	rotation_spawn = rotation_spawn * -1

func _spawn_bullets():
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
	$EnemyHitBox/CollisionShape2D.disabled = true
	tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_CIRC)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2(1.5,1.5), 0.2)
	tween.tween_property($AnimatedSprite2D, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(self.queue_free)

func _on_bullet_spray_timer_timeout():
	spawn_bullets = !spawn_bullets

func _on_shoot_bullets_timer_timeout():
	_spawn_bullets()

func _on_change_rotation_timer_timeout():
	_change_rotation()

func _on_invincibility_timer_timeout():
	can_be_hurt = true 
	$AnimatedSprite2D.play("iddle")
	
func _cast_special_attack():
	$ShootBulletsTimer.wait_time = 0.06
	special_attack = false 
	$SpecialAttackTimer.start()

func _on_special_attack_timer_timeout():
	$ShootBulletsTimer.wait_time = shoot_bullets_timer_wait_time
