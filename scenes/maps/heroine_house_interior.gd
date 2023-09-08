extends Node2D

@onready var transitions = $Transitions 
@onready var open_door_sound = $OpenDoorSound
@onready var house_exterior_scene = load("res://scenes/maps/heroine_house_outside.tscn")

func _ready():
	transitions.enter_screen()

func _on_area_2d_body_entered(body):
	if body.name == "player":
		open_door_sound.play()
		transitions.exit_screen(house_exterior_scene)
