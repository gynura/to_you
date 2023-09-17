extends MarginContainer

@onready var transition = $Transitions
@onready var title_screen = load("res://scenes/screens/title_screen.tscn")
@onready var sound = $ButtonPressedSound

func _ready():
	transition.enter_screen()

func _unhandled_key_input(event):
	if event.is_pressed():
		sound.play()

func _on_button_pressed_sound_finished():
	transition.exit_screen(title_screen)
