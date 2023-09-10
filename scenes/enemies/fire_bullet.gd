extends AnimatedSprite2D

var projectile_direction = Vector2(1, 0)
var projectile_speed = 100
@onready var hitSound = $HitSound 

# This is so I don't edit the player's code since only nodes with life > 0 can damage him,
# I feel like it's cleaner to set this here than to add more casuistic on the player's script 
var currentHealth = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_generate_rotating_bullet()
	
# Check if the bullet hits a wall
func _on_area_2d_body_entered(body):
	if body.name != "FinalBoss" && body.name != "player":
		queue_free()
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
