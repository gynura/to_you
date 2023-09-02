extends Sprite2D

signal attack_end
signal next_attack
signal enemy_hit

var animationDirection
var direction = 0
var damage = 1
var tween 
var final_py
var final_px

func _ready():
	disable_weapon()
	visible = false 

func disable_weapon():
	$HitBox/CollisionShape2D.set_deferred("disabled",true)

func _on_change_direction(dir):
	self.direction = dir

func showWeapon():
	visible = true
	var px = 0
	var py = 0
	match animationDirection:
		"down":
			px = -6
			py = 5
			final_py = 4
		"up":
			px = -3
			py = -21
			final_py = -20
		"right":
			px = 12
			final_px = 13
			py = -4
		"left":
			px = -12
			final_px = -13
			py = -4
	$HitBox/CollisionShape2D.set_deferred("disabled",false)
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "position",Vector2(px,py),0.2)
	# This is really hacky but somehow needed, I wanted to simply use final_px and final_py :S
	if animationDirection == "down" || animationDirection == "up":
		tween.tween_property(self, "position",Vector2(px,final_py),0.2)
	else: 
		tween.tween_property(self, "position",Vector2(final_px,py),0.1)
	tween.tween_callback(end_attack)
	
func set_weapon_position():
	match animationDirection:
		"down":
			self.position = Vector2(-6, 2)
			flip_v = false
			rotation = 0
		"up":
			self.position = Vector2(-3, -17)
			rotation = 0
			flip_v = true 
		"right":
			self.position = Vector2(10, -4)
			flip_v = true
			rotation_degrees = 90
		"left":
			rotation_degrees = 90
			self.position = Vector2(-10, -4)
			flip_v = false
	
func end_attack():
	visible = false
	emit_signal("attack_end")
	disable_weapon()
	$NextAttackTimer.start()

func _on_player_attack_position_changed(position):
	self.animationDirection = position 
	set_weapon_position()

func _on_player_attack():
	showWeapon()

func _on_next_attack_timer_timeout():
	emit_signal("next_attack")

func _on_hit_box_enemy_hurt():
	$HitSound.play()
	emit_signal("enemy_hit")
