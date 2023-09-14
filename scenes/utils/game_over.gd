extends Node2D

@onready var main_title = load("res://scenes/utils/title_screen.tscn")
@onready var transition = $Transitions
@onready var sound = $PlayButtonPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	transition.enter_screen()
	var tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($ContinueText, "self_modulate", Color(1, 1, 1, 0), 1)
	tween.tween_property($ContinueText, "self_modulate", Color(1, 1, 1, 1), 1)
	tween.set_loops()
	
func _process(delta):
	if Input.is_action_just_pressed("attack_button") or Input.is_action_just_pressed("interact_button"):
		sound.play()

func _on_play_button_pressed_finished():
	transition.exit_screen(main_title)
