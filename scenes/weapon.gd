extends Sprite2D

signal attack_end

var animationDirection
var direction = 0
var damage = 1
var tween 

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
	var final_py = -2
	match animationDirection:
		"down":
			px = -4
			py = 4
		"up":
			px = -3
			py = -21
		"right":
			px = 12
			py = -4
		"left":
			px = -12
			py = -4
	$HitBox/CollisionShape2D.set_deferred("disabled",false)
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	##tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(self,"position",Vector2(px,py),0.2)
	tween.tween_property(self, "position",Vector2(px,final_py),0.2)
	tween.tween_callback(end_attack)
	
func set_weapon_position():
	match animationDirection:
		"down":
			self.position = Vector2(0, 4)
			flip_v = false
			rotation = 0
		"up":
			self.position = Vector2(0, 4)
			rotation = 0
			flip_v = true 
		"right":
			self.position = Vector2(0, 4)
			flip_v = false
			rotation = -90
		"left":
			self.position = Vector2(0, 4)
			rotation = 90
			flip_v = false

func set_direction(v):
	direction = v.angle()-PI/2
	rotation = direction
	if v.y > 0:
		z_index = 0
	else:
		z_index = -1
	
func end_attack():
	visible = false
	emit_signal("attack_end")
	disable_weapon()

func _on_hit_box_hit():
	$ImpactFx.emitting = true

func _on_player_attack_position_changed(position):
	self.animationDirection = position 
	set_weapon_position()
	showWeapon()
