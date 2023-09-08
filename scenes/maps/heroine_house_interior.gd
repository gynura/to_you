extends Node2D

var heroine_house_outside = preload("res://scenes/maps/heroine_house_outside.tscn")
@onready var player = $player

func _ready():
	# TODO add here the code for the initial cutscene of the game 
	pass

func change_scene(): 
	player.exit_screen_animation()

func _on_check_for_player_exit_body_entered(body):
	if body.name == "player":
		change_scene()

func _on_player_exited_scene():
	get_tree().change_scene_to_packed(heroine_house_outside)


func _on_player_entered_scene():
	pass # Replace with function body.
