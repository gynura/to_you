extends Node2D

@onready var transitions = $Transitions
@onready var open_door_sound = $OpenDoorSound 
@onready var house_interior_scene = load("res://scenes/maps/heroine_house_interior.tscn")
@onready var second_map = load("res://scenes/maps/forest.tscn")
@onready var speech_sound = preload("res://assets/sound/fx/ReadSpeech.wav")
@onready var wall = $Wall
@onready var gui = $GUI
@onready var grass_sound = $GrassStep
var player

func _ready():
	Global.begin_game = false 
	transitions.enter_screen()
	DialogManager.dialog_ended.connect(_hide_dialog_marker)
	if Global.player_got_weapon:
		_player_got_weapon_behaviour()

func _on_area_2d_body_entered(body):
	if body.name == "player":
		gui.visible = false
		open_door_sound.play()
		transitions.exit_screen(house_interior_scene)

func _on_check_if_player_has_weapon_area_body_entered(body):
	if body.name == "player":
		if !Global.player_got_weapon:
			player = body
			DialogManager.stop_player.emit()
			body.show_dialog_marker()
			var dialog_lines :Array[String] = [
				"¡La señora Rana me esta esperando!",
			]
			DialogManager.start_dialog(player.global_position, dialog_lines, speech_sound)

func _hide_dialog_marker():
	if player != null: 
		player.hide_dialog_marker()

func _player_got_weapon_behaviour():
	wall.queue_free()
	$BackgroundMusic.stop()
	$WeaponObtainedMusic.play()

func _on_froggy_give_weapon_to_player():
	_player_got_weapon_behaviour()

func _on_background_music_finished():
	$BackgroundMusic.play()

func _on_weapon_obtained_music_finished():
	$WeaponObtainedMusic.play()

func _on_check_for_second_area_body_entered(body):
	if body.name == "player":
		gui.visible = false
		grass_sound.play()
		transitions.exit_screen(second_map)

func _on_grass_step_finished():
	grass_sound.play()
