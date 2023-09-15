extends MarginContainer

@onready var transition = $Transitions
@onready var main_title = load("res://scenes/screens/title_screen.tscn")
@onready var sound = $PlayButtonPressed

func _ready():
	transition.enter_screen()


func _unhandled_key_input(event):
	if event.is_pressed():
		sound.play()

func _on_play_button_pressed_finished():
	transition.exit_screen(main_title)
