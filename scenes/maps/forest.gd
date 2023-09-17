extends Node2D

@onready var transitions = $Transitions 
@onready var boss_fight = load("res://scenes/maps/boss_fight.tscn")
@onready var gui = $GUI
@onready var grass_sound = $GrassStep
@onready var speech_sound = preload("res://assets/sound/fx/read_speech.wav")
@onready var game_over_screen = load("res://scenes/screens/game_over_scene.tscn")
@onready var wall = $Wall
var grass_sound_repeat :bool = false 

func _ready():
	transitions.enter_screen()
	Global.first_area_completed.connect(_allow_boss_fight)

func _on_check_before_boss_body_entered(body):
		if body.name == "player":
			grass_sound_repeat = true 
			gui.visible = false
			grass_sound.play()
			transitions.exit_screen(boss_fight)

func _allow_boss_fight():
	wall.queue_free()

func _on_grass_step_finished():
	if grass_sound_repeat:
		grass_sound.play()

func _on_check_if_all_enemies_killed_body_entered(body):
	if body.name == "player":
		print_debug(Global.enemies_in_first_area)
		if Global.enemies_in_first_area > 0:
			print_debug("zanahoria")
			DialogManager.stop_player.emit()
			body.show_dialog_marker()
			var dialog_lines :Array[String] = [
				"¡Aún quedan enemigos en esta zona!",
			]
			DialogManager.start_dialog(body.global_position, dialog_lines, speech_sound)

func _on_background_music_finished():
	$BackgroundMusic.play()

func _on_player_game_over():
	$BackgroundMusic.stop()
	$GameOverSound.play()

func _on_game_over_sound_finished():
	transitions.exit_screen(game_over_screen)
