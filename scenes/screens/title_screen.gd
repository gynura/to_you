extends Control

@onready var heart = $Heart 
@onready var music = $TittleScreenMusic
@onready var flash = $ColorRect/FlashPlayer
@onready var buttons = $Buttons 
@onready var transition = $Transitions
@onready var exit_button_sound = $ExitButtonPressed
@onready var play_button_sound = $PlayButtonPressed
@onready var change_button_sound = $ChangeButton
@onready var house_interior_scene = preload("res://scenes/maps/heroine_house_interior.tscn")
@onready var selector_one = $Buttons/StartButton/Selector
@onready var selector_two = $Buttons/ExitButton/Selector
@onready var start_button = $Buttons/StartButton/Start
@onready var exit_button = $Buttons/ExitButton/Exit

@onready var not_intro :bool = false 
var current_selection = 0 
var selected_button
var tween

# Called when the node enters the scene tree for the first time.
func _ready():
	set_selected_button(0)
	transition.enter_screen()
	start_button.self_modulate = Color(1, 1, 1, 0)
	exit_button.self_modulate = Color(1, 1, 1, 0)
	selector_one.self_modulate = Color(1, 1, 1, 0)
	selector_two.self_modulate = Color(1, 1, 1, 0)
	var tween_new = create_tween()
	tween_new.tween_property(heart, "position", Vector2(120,67), 2)
	tween_new.connect("finished", _animate_heart_loop)
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_down") and current_selection < 1:
		current_selection += 1
		set_selected_button(current_selection)
	elif Input.is_action_just_pressed("ui_up") and current_selection > 0:
		current_selection -= 1
		set_selected_button(current_selection)
	elif Input.is_action_just_pressed("attack_button") or Input.is_action_just_pressed("interact_button"):
		press_button(current_selection)
	
func press_button(_current_selection):
	match _current_selection:
		0: # start button
			Global.reset_game()
			play_button_sound.play()
		1: # exit button
			exit_button_sound.play()
			
func _play_button_animation():
	if tween != null: 
		tween.stop()
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(selected_button, "theme_override_font_sizes/font_size", 8, 0.4)
	tween.tween_property(selected_button, "theme_override_font_sizes/font_size", 10, 0.4)
	tween.set_loops()

func set_selected_button(_current_selection):
	selector_one.text = ""
	selector_two.text = ""
	if not_intro:
		$ChangeButton.play()
	match _current_selection:
		0:  # start 
			selected_button = selector_one
			selector_one.text = "*"
		1:  # exit
			selected_button = selector_two
			selector_two.text = "*"
	_play_button_animation()

func _animate_heart_loop():
	music.play()
	_play_flash()
	var heart_tween = create_tween()
	heart_tween.set_ease(Tween.EASE_OUT)
	heart_tween.set_trans(Tween.TRANS_QUAD)
	heart_tween.tween_property(heart, "scale", Vector2(0.95,0.95), 0.5)
	heart_tween.tween_property(heart, "scale", Vector2.ONE, 0.5)
	heart_tween.set_loops()

func _on_tittle_screen_music_finished():
	music.play()
	
func _animate_button_letters():
	pass 

func _play_flash():
	var flash_tween = create_tween()
	flash_tween.set_parallel(true)
	flash_tween.set_ease(Tween.EASE_OUT)
	flash_tween.set_trans(Tween.TRANS_BOUNCE)
	flash_tween.tween_property(start_button, "self_modulate", Color(1, 1, 1, 1), 1.5)
	flash_tween.tween_property(exit_button, "self_modulate", Color(1, 1, 1, 1), 1.5)
	flash_tween.tween_property(selector_one, "self_modulate", Color(1, 1, 1, 1), 1.5)
	flash_tween.tween_property(selector_two, "self_modulate", Color(1, 1, 1, 1), 1.5)
	flash.play("flash")
	not_intro = true

func _on_exit_button_pressed_finished():
	get_tree().quit()

func _on_play_button_pressed_finished():
	transition.exit_screen(house_interior_scene)
