extends Control

@onready var heart = $Heart 
@onready var music = $TittleScreenMusic
@onready var flash = $ColorRect/FlashPlayer
@onready var buttons = $Buttons 
@onready var transition = $Transitions
@onready var exit_button_sound = $Buttons/ExitButton/ExitButtonPressed
@onready var play_button_sound = $Buttons/PlayButton/PlayButtonPressed

# Called when the node enters the scene tree for the first time.
func _ready():
	transition.enter_screen()
	buttons.self_modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(heart, "position", Vector2(120,67), 2)
	tween.connect("finished", _animate_heart_loop)

func _animate_heart_loop():
	music.play()
	_play_flash()
	var tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(heart, "scale", Vector2(0.95,0.95), 0.5)
	tween.tween_property(heart, "scale", Vector2.ONE, 0.5)
	tween.set_loops()

func _on_tittle_screen_music_finished():
	music.play()
	
func _animate_button_letters():
	pass 

func _play_flash():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(buttons, "self_modulate", Color(1, 1, 1, 1), 1.5)
	flash.play("flash")

func _on_flash_player_animation_finished(anim_name):
	if anim_name == "flash": 
		pass

func _on_exit_button_pressed():
	exit_button_sound.play()

func _on_exit_button_pressed_finished():
	get_tree().quit()
