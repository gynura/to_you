extends HBoxContainer

@onready var flowerGUIClass = preload("res://scenes/UI/flower_gui.tscn")
@onready var already_animated_one_flower :bool = false 

func setMaxFlowers(maxHealth: int):
	for i in range(maxHealth):
		var flower = flowerGUIClass.instantiate()
		add_child(flower)

# Flowers are filled from left to right
func updateFlowers(currentHealth: int):
	var flowers = get_children()
	var fullFlowers = currentHealth/4 
	var remainingLife = currentHealth - fullFlowers * 4
	for i in range (flowers.size()):
		flowers[i].stop_animation()
		if i < fullFlowers:
			flowers[i].update(4) 
			if !already_animated_one_flower && i == fullFlowers - 1:
				if remainingLife == 0:
					flowers[i].activate_animation()
					already_animated_one_flower = true 
		else:
			# There can only be one flower between 0 and 4 petals at the time:
			if remainingLife != 0 && i < flowers.size():
				flowers[i].update(remainingLife)
				flowers[i].activate_animation()
				already_animated_one_flower = false
				return
				
			flowers[i].update(remainingLife)
			
	already_animated_one_flower = false 
