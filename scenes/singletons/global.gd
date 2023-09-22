extends Node

const PLAYER_MAX_HEALTH = 12  

var begin_game = true 
var player_got_weapon = false 
#TODO cambiar los dos de arriba!!! 

var player_getting_weapon :bool = false 
var player_current_health = 12
var is_froggy_talk = false
var enemies_in_first_area = 9

signal player_heal 
signal transition_to_scene
signal entered_new_scene
signal restart_player
signal killed_flame_boss
signal game_completed
signal first_area_completed

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func reset_game():
	begin_game = true
	player_got_weapon = false 
	player_current_health = 12
	is_froggy_talk = false
	enemies_in_first_area = 9 
	player_getting_weapon = false 
