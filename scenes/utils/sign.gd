extends Sprite2D

var canInteract = false 
@onready var speech_sound = preload("res://assets/sound/fx/ReadSpeech.wav")

func _ready():
	DialogManager.read_sign_start.connect(_show_dialog_marker)
	DialogManager.read_sign_stop.connect(_hide_dialog_marker)

func _physics_process(delta):
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
	DialogManager.start_read_sign(global_position, dialog_lines, speech_sound)
	
func _show_dialog_marker():
	$DialogMarker.visible = true

func _hide_dialog_marker():
	$DialogMarker.visible = false 
	
func _on_area_2d_body_entered(body):
	if body.name == "player": 
		$Bubble.visible = true
		$Bubble.play("default")
		canInteract = true 

func _on_area_2d_body_exited(body):
	if body.name == "player": 
		$Bubble.stop()
		$Bubble.visible = false 
		canInteract = false 
