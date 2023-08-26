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

# Flowers begin depleted and have to be filled
# They are filled from left to right
func updateFlowers(currentHealth: int):
	var flowers = get_children()
	var fullFlowers = currentHealth/4
	print(fullFlowers)
	# First we fill the hearts that will be full
	for i in range(fullFlowers):
		flowers[i].update(4)
	if fullFlowers == flowers.size():
		return
	##var remainingFlowersToUpdate = flowers.size() - fullFlowers 
	var remainingLife = currentHealth - fullFlowers * 4
	flowers[fullFlowers].update(remainingLife)

