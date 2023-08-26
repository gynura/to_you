extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_parent().get_node("player")
	$HealthContainer.setMaxFlowers(player.MAX_HEALTH/4)
	$HealthContainer.updateFlowers(player.currentHealth)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
