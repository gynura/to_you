extends CharacterBody2D

var canInteract = false 
@onready var speech_sound = preload("res://assets/sound/fx/froggy_speech.wav")

signal give_weapon_to_player

func _ready():
	DialogManager.dialog_ended.connect(_dialog_ended)
	DialogManager.dialog_start.connect(_show_dialog_marker)

func _physics_process(_delta):
	if Input.is_action_just_pressed("interact_button"):
		if canInteract and !Global.player_getting_weapon:
			$Bubble.stop()
			$Bubble.visible = false 
			talkToFroggy()

func talkToFroggy():
	_hide_hearts()
	DialogManager.stop_player.emit()
	_show_dialog_marker()
	set_process(false)
	Global.is_froggy_talk = true 
	var dialog_lines: Array[String]
	if !Global.player_got_weapon:
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
		Global.player_getting_weapon = true 
	else: 
		dialog_lines = [
			"¡¡Confiamos en ti!!",
		]
	canInteract = false 
	DialogManager.start_dialog(global_position, dialog_lines, speech_sound)
	
func _on_area_2d_body_entered(body):
	if body.name == "player": 
		$Bubble.visible = true
		$Bubble.play("default")
		canInteract = true 
		$PopUp.play()

func _on_area_2d_body_exited(body):
	if body.name == "player": 
		$Bubble.stop()
		$Bubble.visible = false 
		canInteract = false 

func _dialog_ended():
	$DialogMarker.visible = false 
	if !Global.player_got_weapon && Global.is_froggy_talk:
		# The frog gives the heroine its weapon!
		give_weapon_to_player.emit()
		Global.is_froggy_talk = false
	elif Global.is_froggy_talk: 
		$Heart.visible = true
		$LittleFrog1/Heart.visible = true
		$LittleFrog2/Heart.visible = true 
		$HeartsTimer.start()
		Global.is_froggy_talk = false 
	$TimeBetweenInteractions.start()

func _show_dialog_marker():
	$DialogMarker.visible = true

func _hide_hearts():
	$Heart.visible = false
	$LittleFrog1/Heart.visible = false
	$LittleFrog2/Heart.visible = false 

func _on_hearts_timer_timeout():
	_hide_hearts()

func _on_time_between_interactions_timeout():
	canInteract = true 
