extends Node

const PLAYER_MAX_HEALTH = 12  

var begin_game = true 
var player_got_weapon = true 
var player_current_health = 12
var is_froggy_talk = false

signal player_heal 
signal transition_to_scene
signal entered_new_scene
signal restart_player

func reset_game():
	begin_game = true
	player_got_weapon = false 
	player_current_health = 12
	is_froggy_talk = false
