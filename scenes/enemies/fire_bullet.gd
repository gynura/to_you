extends AnimatedSprite2D

var projectile_direction = Vector2(1, 0)
var projectile_speed = 100
@onready var hitSound = $HitSound 
var is_deleted :bool = false 

# This is so I don't edit the player's code since only nodes with life > 0 can damage him,
# I feel like it's cleaner to set this here than to add more casuistic on the player's script 
var currentHealth = 1

func _ready():
	Global.killed_flame_boss.connect(_delete_bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	_generate_rotating_bullet()
	
func _delete_bullet():
	queue_free()
	
# Check if the bullet hits a wall
func _on_area_2d_body_entered(body):
	if body.name != "FinalBoss" && body.name != "player" && body.name != "Wall2":
		$HitFx.emitting = true 
		currentHealth -= 1
		self_modulate = "#ffffff00"
		$EnemyHitBox/CollisionShape2D.set_deferred("disabled", true) 
		$TimeTillDeletion.start()
#	elif body.name == "player":
#		self_modulate = "#ffffff00"
		
func _generate_rotating_bullet():
	# Bullets are generated with their asigned rotation
	self.position += projectile_direction.rotated(self.rotation)
	
func get_velocity():
	return projectile_direction 

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_hit_sound_finished():
	queue_free()

func _on_time_till_deletion_timeout():
	queue_free()
