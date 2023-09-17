extends Control

@onready var animations :AnimationPlayer = $AnimationPlayer
@onready var color_rect :ColorRect = $AnimationPlayer/ColorRect 
var scene_to_load :PackedScene

func _ready():
	color_rect.visible = false 

func exit_screen(scene):
	scene_to_load = scene
	color_rect.visible = true
	Global.transition_to_scene.emit()
	animations.play("fade_in")
	
func enter_screen(): 
	color_rect.visible = true
	animations.play("fade_out")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		get_tree().change_scene_to_packed(scene_to_load)
		queue_free()
	else: 
		Global.entered_new_scene.emit()
	color_rect.visible = false 
