extends Node2D

@onready var camera = $BossFightCamera
@onready var check_to_change_camera = $Area2D
@onready var transition_camera = $TransitionCamera
@onready var first_camera = $FirstCamera

signal start_boss_fight

func _ready():
	$Wall/CollisionShape2D.disabled = true
	first_camera.make_current()

# This function changes to a third camera to create a smooth transition between them
func _transition_cameras():
	transition_camera.offset = first_camera.offset 
	transition_camera.position = first_camera.position
	transition_camera.global_transform = first_camera.global_transform
	transition_camera.rotation = first_camera.rotation
	transition_camera.global_position = first_camera.global_position
	transition_camera.limit_bottom = first_camera.limit_bottom
	transition_camera.limit_top = first_camera.limit_top
	transition_camera.limit_right = first_camera.limit_right
	transition_camera.limit_left = first_camera.limit_left 
	transition_camera.make_current()
	
	$TimeBetweenCameraChanges.start()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(transition_camera, "global_transform", camera.global_transform, 1)
	tween.tween_property(transition_camera, "offset", camera.offset, 1)
	tween.tween_property(transition_camera, "position", camera.position, 0.4)
	tween.tween_property(transition_camera, "rotation", camera.rotation, 0.4)
	tween.connect("finished", _change_to_boss_fight_camera)

func _change_to_boss_fight_camera():
	camera.make_current()

func _on_area_2d_body_entered(body):
	if body.name == "player":
		DialogManager.stop_player.emit()
		_transition_cameras()
		check_to_change_camera.queue_free()


func _on_time_between_camera_changes_timeout():
	
	Global.restart_player.emit()
	$Wall/CollisionShape2D.disabled = false 
	start_boss_fight.emit()
