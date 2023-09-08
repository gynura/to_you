extends Control

@onready var animations :AnimationPLayer = $AnimationPlayer
@onready var color_rect :ColorRect = $ColorRect 


func _ready():
	color_rect.visible = false 

func exit_screen_animation():
	animations.play("fade_in")
	
func enter_screen_animation(): 
