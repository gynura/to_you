extends CharacterBody2D

var canInteract = false 

func _ready():
	DialogManager.dialog_ended.connect(_hide_dialog_marker)
	DialogManager.dialog_start.connect(_show_dialog_marker)

func _physics_process(delta):
	if Input.is_action_just_pressed("interact_button"):
		if canInteract:
			$Bubble.stop()
			$Bubble.visible = false 
			talkToFroggy()

func talkToFroggy():
	_show_dialog_marker()
	set_process(false)
	var dialog_lines: Array[String] = [
		"Test del sistema de dialogo",
		"Test test test test test test",
		"Coi deja de beber y codea guarro,",
		" te queremos de vuelta",
	] 
	DialogManager.start_dialog(global_position, dialog_lines)
	
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

func _hide_dialog_marker():
	$DialogMarker.visible = false 

func _show_dialog_marker():
	$DialogMarker.visible = true
