extends AnimatedSprite2D

var projectile_direction = Vector2(1, 0)
var projectile_speed = 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_generate_rotating_bullet()
	
# Check if the bullet hits a wall
func _on_area_2d_body_entered(body):
	if body.name != "player": 
		queue_free()
		
func _generate_rotating_bullet():
	# Bullets are generated with their asigned rotation
	self.position += projectile_direction.rotated(self.rotation)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
