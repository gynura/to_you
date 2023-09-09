extends MarginContainer


@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer
@onready var audio_player = $AudioStreamPlayer

const MAX_WIDTH = 256

var text = ""
var letter_index = 0
var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2
var marker_position_x = 7 
var marker_position_y = 17 

signal finished_display() 

func display_text(text_to_display: String, speech_effect: AudioStream):
	text = text_to_display
	label.text = text_to_display 
	audio_player.stream = speech_effect 
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # waiting for the x resize
		await resized # waiting for the y resize
		custom_minimum_size.y = size.y 
	
	global_position.x -= size.x/2
	global_position.y -= size.y + 20
	
	label.text = ""
	_display_letter()
	
func _display_letter():
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_display.emit()
		return
		
	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			
			var letter_speech_effect_player = audio_player.duplicate()
			letter_speech_effect_player.pitch_scale += randf_range(-0.1, 0.1)
			if text[letter_index] in ["a", "e", "i", "o", "u"]:
				letter_speech_effect_player.pitch_scale += 0.2
			get_tree().root.add_child(letter_speech_effect_player)
			letter_speech_effect_player.play()
			await letter_speech_effect_player.finished
			letter_speech_effect_player.queue_free()

func _on_letter_display_timer_timeout():
	_display_letter()
	
# This function is used for read signs 
func display_sign_text(text_to_display: String, speech_effect: AudioStream):
	text = text_to_display
	label.text = text_to_display 
	audio_player.stream = speech_effect 
	
	await resized
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # waiting for the x resize
		await resized # waiting for the y resize
		custom_minimum_size.y = size.y 
	
	global_position.x -= size.x/2
	global_position.y -= size.y + 10
	
	label.text = ""
	_display_letter()
