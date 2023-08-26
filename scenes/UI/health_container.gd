extends HBoxContainer

@onready var flowerGUIClass = preload("res://scenes/UI/flower_gui.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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

