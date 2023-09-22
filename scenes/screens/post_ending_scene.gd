extends Node2D

@onready var start_camera = $StartCamera
@onready var ending_camera = $EndingCamera
@onready var zoomed_camera = $ZoomCamera
@onready var ending_letters = $TheEnd
@onready var transitions = $Transitions
@onready var main_title = preload("res://scenes/screens/title_screen.tscn")

func _ready():
	ending_letters.self_modulate = Color(1,1,1,0)
	start_camera.make_current()
	transitions.enter_screen()
	_ending_cinematic()

func _ending_cinematic():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(start_camera, "global_transform", ending_camera.global_transform, 3)
	tween.tween_callback(_zoom_camera)
	
func _zoom_camera():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(start_camera, "global_transform", zoomed_camera.global_transform, 2.5)
	tween.tween_property(start_camera, "zoom", zoomed_camera.zoom, 2)
	tween.tween_callback(_show_ending_letters)
	
func _show_ending_letters():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(ending_letters, "self_modulate", Color(1, 1, 1, 1), 2.5)
	tween.tween_callback(_show_hearts)
	
func _show_hearts():
	$Heroine/Heart.visible = true
	$HeroineBoyfriend/Heart.visible = true
	$Doggy/Heart.visible = true 
	$ExitToTittleScreenTimer.start()

func _on_exit_to_tittle_screen_timer_timeout():
	transitions.exit_screen(main_title)
