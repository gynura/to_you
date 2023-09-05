extends CharacterBody2D

const MAX_HEALTH = 7

@export var speed = 42
@onready var bullet_scene = preload("res://scenes/enemies/fire_bullet.tscn")
var current_health = 7
var is_hurt :bool = false 
var spawn_bullets :bool = true 
var rotation_spawn = 0.3 #Empezamos en 0.3 hasta 0.5

func _spawn_bullets():
	if spawn_bullets:
		print_debug("zanahoria")
		$BulletSpawner.rotate(rotation_spawn)
		var bullet = bullet_scene.instantiate()
		bullet.position = self.position
		bullet.rotation = $BulletSpawner.rotation
		get_parent().add_child(bullet)

func _on_bullet_spray_timer_timeout():
	spawn_bullets = !spawn_bullets


func _on_shoot_bullets_timer_timeout():
	_spawn_bullets()
