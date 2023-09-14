extends Node2D

@onready var transitions = $Transitions 
@onready var open_door_sound = $OpenDoorSound
@onready var house_exterior_scene = load("res://scenes/maps/heroine_house_outside.tscn")
@onready var player = $player
@onready var game_beginning_player_position = $GameBeginningPlayerPosition
@onready var gui = $GUI
var number_of_door_hits = 2

signal start_first_dialog

func _ready():
	transitions.enter_screen()
	if Global.begin_game: 
		$BackgroundMusic.stop()
		player.global_position = game_beginning_player_position.global_position
		$player._stop_player()
		$HitDoorSound.play()
		number_of_door_hits-=1

func _on_area_2d_body_entered(body):
	if body.name == "player":
		open_door_sound.play()
		gui.visible = false
		transitions.exit_screen(house_exterior_scene) 

func _on_background_music_finished():
	$BackgroundMusic.play()

func _on_hit_door_sound_finished():
	DialogManager.stop_player.emit()
	set_process(false)
	player.show_dialog_marker()
	start_first_dialog.emit()
	if number_of_door_hits > 0:
		$HitDoorSound.play()
		number_of_door_hits-=1
		Global.begin_game = false 
