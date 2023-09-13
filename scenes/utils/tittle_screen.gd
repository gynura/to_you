extends Control

@onready var heart = $Heart 
@onready var music = $TittleScreenMusic

# Called when the node enters the scene tree for the first time.
func _ready():
	#heart.position = Vector2(120, 44)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(heart, "position", Vector2(120,67), 2)
	tween.connect("finished", _animate_heart_loop)

func _animate_heart_loop():
	var tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(heart, "scale", Vector2(0.95,0.95), 0.5)
	tween.tween_property(heart, "scale", Vector2.ONE, 0.5)
	tween.set_loops()

func _on_tittle_screen_music_finished():
	music.play()
