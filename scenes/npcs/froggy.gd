extends CharacterBody2D

var canInteract = false 
@onready var speech_sound = preload("res://assets/sound/fx/FroggySpeech.wav")
var already_gave_weapon = false 

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
	_hide_hearts()
	DialogManager.stop_player.emit()
	_show_dialog_marker()
	set_process(false)
	var dialog_lines: Array[String]
	if !already_gave_weapon:
		dialog_lines = [
			"¡Hola Yaiza!",
			"Te estábamos esperando,",
			" Necesitamos tu ayuda",
			"El bosque se esta quemando",
			" Y solo tú tienes la fuerza para liberarlo",
			"Es peligroso que vayas desarmada",
			"Toma esto y sálvanos",
			"¡¡Confiamos en ti!!"
		]
	else: 
		dialog_lines = [
			"¡¡Confiamos en ti!!",
		]
	DialogManager.start_dialog(global_position, dialog_lines, speech_sound)
	
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
	if !already_gave_weapon:
		already_gave_weapon = true
	else:
		$Heart.visible = true
		$LittleFrog1/Heart.visible = true
		$LittleFrog2/Heart.visible = true 
		$HeartsTimer.start()

func _show_dialog_marker():
	$DialogMarker.visible = true

func _hide_hearts():
	$Heart.visible = false
	$LittleFrog1/Heart.visible = false
	$LittleFrog2/Heart.visible = false 

func _on_hearts_timer_timeout():
	_hide_hearts()
