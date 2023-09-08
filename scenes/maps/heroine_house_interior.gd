extends Node2D

@onready var transitions = $Transitions 
@onready var open_door_sound = $OpenDoorSound

func _ready():
	# TODO add here the first cutscene of the game
	pass # Replace with function body.

func _on_area_2d_body_entered(body):
	print_debug(body.name)
	if body.name == "player":
		open_door_sound.play()
		transitions.exit_screen()
