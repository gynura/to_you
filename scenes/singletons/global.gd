extends Node

const PLAYER_MAX_HEALTH = 12  

var begin_game = true 
var player_got_weapon = true 
var player_current_health = 12

signal player_heal 

func reset_game():
	begin_game = true
	player_got_weapon = false 
	player_current_health = 12
