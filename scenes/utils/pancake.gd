extends Sprite2D

var tween 
@onready var heal_sound :AudioStreamPlayer2D = $HealUpSound

func _ready():
	activate_animation()

func activate_animation(): 
	tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale", Vector2(0.85,0.85), 0.5)
	tween.tween_property(self, "scale", Vector2.ONE, 0.5)
	tween.set_loops()

func stop_animation():
	if tween != null:
		tween.stop()

func remove_from_scene():
	$Area2D/CollisionShape2D.disabled = true
	var remove_from_scene_tween = create_tween()
	remove_from_scene_tween.set_ease(tween.EASE_OUT)
	remove_from_scene_tween.set_trans(Tween.TRANS_CIRC)
	remove_from_scene_tween.tween_property(self, "scale", Vector2(0.8,0.8), 0.2)
	remove_from_scene_tween.tween_property(self, "scale", Vector2.ZERO, 0.5)
	remove_from_scene_tween.tween_callback(self.queue_free)

func _on_area_2d_body_entered(body):
	if body.name == "player":
		if Global.player_current_health < Global.PLAYER_MAX_HEALTH:
			Global.player_heal.emit()
			stop_animation()
			heal_sound.play()
			remove_from_scene()
