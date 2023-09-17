extends Sprite2D

var canInteract = false 
var is_player_near = false 
@onready var speech_sound = preload("res://assets/sound/fx/read_speech.wav")

func _ready():
	DialogManager.read_sign_start.connect(_show_dialog_marker)
	DialogManager.read_sign_stop.connect(_dialog_ended)

func _physics_process(_delta):
	if is_player_near: 
		if Input.is_action_just_pressed("interact_button"):
			if canInteract:
				$Bubble.stop()
				$Bubble.visible = false 
				_read_sign()

func _read_sign():
	DialogManager.stop_player.emit()
	_show_dialog_marker()
	set_process(false)
	var dialog_lines :Array[String] = [
		"Caseta Floretes",
	]
	canInteract = false 
	DialogManager.start_read_sign(global_position, dialog_lines, speech_sound)
	
func _show_dialog_marker():
	$DialogMarker.visible = true

func _dialog_ended():
	$DialogMarker.visible = false 
	$TimeBetweenInteractions.start()
	
func _on_area_2d_body_entered(body):
	if body.name == "player": 
		is_player_near = true 
		$Bubble.visible = true
		$Bubble.play("default")
		canInteract = true 
		$PopUp.play()

func _on_area_2d_body_exited(body):
	if body.name == "player": 
		is_player_near = false
		$Bubble.stop()
		$Bubble.visible = false 
		canInteract = false 

func _on_time_between_interactions_timeout():
	canInteract = true 
