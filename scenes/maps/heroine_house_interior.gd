extends Node2D

@onready var transitions = $Transitions 
@onready var open_door_sound = $OpenDoorSound
@onready var house_exterior_scene = load("res://scenes/maps/heroine_house_outside.tscn")
@onready var player = $player
@onready var game_beginning_player_position = $GameBeginningPlayerPosition

func _ready():
	transitions.enter_screen()
	if Global.begin_game: 
		player.global_position = game_beginning_player_position.global_position
		DialogManager.stop_player.emit()

func _on_area_2d_body_entered(body):
	if body.name == "player":
		open_door_sound.play()
		transitions.exit_screen(house_exterior_scene)
