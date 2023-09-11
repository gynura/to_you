extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($ContinueText, "self_modulate", Color(1, 1, 1, 0), 1)
	tween.tween_property($ContinueText, "self_modulate", Color(1, 1, 1, 1), 1)
	tween.set_loops()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
