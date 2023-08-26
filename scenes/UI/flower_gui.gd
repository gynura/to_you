extends Panel

# Each life is a petal of a flower, each flower can hold up to 4 petals
# This function should never recieve a number greater than 4
func update(life: int):
	match life: 
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
