extends Node

@onready var text_box_scene = preload("res://scenes/UI/text_box.tscn")
var dialog_lines : Array[String] = []
var current_line_index = 0 
var text_box
var text_box_position: Vector2
var is_dialog_active = false
var can_advance_line = false

var is_reading_sign :bool = false

var sound_effect: AudioStream

signal dialog_start
signal dialog_ended
signal read_sign_stop
signal read_sign_start
signal stop_player

func _unhandled_input(event):
	if (event.is_action_pressed("advance_dialog") && is_dialog_active && can_advance_line):
		if is_reading_sign:
			read_sign_start.emit()
		else :
			dialog_start.emit()
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false 
			current_line_index = 0
			if is_reading_sign: 
				read_sign_stop.emit()
			else:
				dialog_ended.emit()
			return 
		
		if is_reading_sign:
			_show_sign_text_box() 
		else: 
			_show_text_box()

func start_dialog(position: Vector2, lines: Array[String], speech_effect: AudioStream):
	is_reading_sign = false 
	if is_dialog_active: 
		return 
		
	dialog_lines = lines
	text_box_position = position
	sound_effect = speech_effect
	_show_text_box()
	
	is_dialog_active = true 
	
func start_read_sign(position: Vector2, lines: Array[String], speech_effect: AudioStream):
	is_reading_sign = true 
	if is_dialog_active: 
		return 
		
	dialog_lines = lines
	text_box_position = position
	sound_effect = speech_effect
	_show_sign_text_box()
	
	is_dialog_active = true 
	
func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_display.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index], sound_effect)
	can_advance_line = false 
	
func _show_sign_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_display.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_sign_text(dialog_lines[current_line_index], sound_effect)
	can_advance_line = false 

func _on_text_box_finished_displaying():
	can_advance_line = true 
