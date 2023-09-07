extends Panel

var tween
var petals :int 

# Each life is a petal of a flower, each flower can hold up to 4 petals
# This function should never recieve a number greater than 4
func update(life: int):
	petals = life 
	match petals: 
		0:
			$Sprite2D.frame = 4
		1:
			$Sprite2D.frame = 3
		2:
			$Sprite2D.frame = 2
		3:
			$Sprite2D.frame = 1
		4: 
			$Sprite2D.frame = 0
			
func activate_animation(): 
	tween = create_tween()
	tween.set_ease(tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property($Sprite2D, "scale", Vector2(0.95,0.95), 0.5)
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.5)
	tween.set_loops()

func stop_animation():
	if tween != null:
		tween.stop()
