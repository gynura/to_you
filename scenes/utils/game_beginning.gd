extends Marker2D

@onready var speech_sound = preload("res://assets/sound/fx/ReadSpeech.wav")

signal restart_music

func _ready():
	DialogManager.dialog_ended.connect(_restart_music)

func _on_heroine_house_interior_start_first_dialog():
	var dialog_lines :Array[String] = [
		"¡Parece que estan llamando a la puerta!",
		"Alguien me estará esperando fuera",
	]
	DialogManager.start_dialog(global_position, dialog_lines, speech_sound)

func _restart_music():
	restart_music.emit()
