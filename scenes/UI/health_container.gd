extends HBoxContainer

@onready var flowerGUIClass = preload("res://scenes/UI/flower_gui.tscn")

func setMaxFlowers(maxHealth: int):
	for i in range(maxHealth):
		var flower = flowerGUIClass.instantiate()
		add_child(flower)

# Flowers are filled from left to right
func updateFlowers(currentHealth: int):
	var flowers = get_children()
	var fullFlowers = currentHealth/4 
	for i in range (flowers.size()):
		if i < fullFlowers:
			flowers[i].update(4)
		else:
			var remainingLife = currentHealth - fullFlowers * 4
			# There can only be one flower between 0 and 4 petals at the time:
			if remainingLife != 0 && i < flowers.size():
				flowers[i].update(remainingLife)
				return
			flowers[i].update(remainingLife)
			
	_animate_last_flower(flowers)

func _animate_last_flower(flowers):
	flowers.reverse()
	var already_animated_one_flower :bool = false 
	# Check to update flower animation on the current flower that can lose petals
	for i in range (flowers.size()):
		if flowers[i].petals > 0 && !already_animated_one_flower: 
			flowers[i].activate_animation()
			already_animated_one_flower = true 
		else: 
			flowers[i].stop_animation()
