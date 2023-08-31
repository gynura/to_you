extends CanvasLayer

@onready var player = get_parent().get_node("player")
# Called when the node enters the scene tree for the first time.
func _ready():
	$HealthContainer.setMaxFlowers(player.MAX_HEALTH/4)
	$HealthContainer.updateFlowers(player.currentHealth)

func _on_player_health_change():
	$HealthContainer.updateFlowers(player.currentHealth)
