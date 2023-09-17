extends Node2D

@onready var transition = $Transitions 
@onready var main_title = preload("res://scenes/screens/title_screen.tscn")
@onready var sound = $PlayButtonPressed
@onready var victory_title = $VictoryLetters

func _ready():
	transition.enter_screen()
	var tween = create_tween()
	tween.tween_property(victory_title, "position", Vector2(121,72), 3)
	tween.connect("finished", _play_flash)

func _process(_delta):
	if Input.is_action_just_pressed("attack_button") or Input.is_action_just_pressed("interact_button"):
		sound.play()

func _on_play_button_pressed_finished():
	transition.exit_screen(main_title)
	
func _play_flash():
	$VictoryTitleSound.play()
	$ColorRect/FlashPlayer.play("flash")
	var tween = create_tween()
	tween.tween_property($VictoryMessage, "self_modulate",Color(1, 1, 1, 1), 0.5)

func _on_music_finished():
	$Music.play()

func _on_flash_player_animation_finished(_anim_name):
	$Music.play()
