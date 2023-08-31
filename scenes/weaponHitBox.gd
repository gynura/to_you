extends Area2D

func _on_area_entered(area):
	if area.name == "EnemyHitBox":
		area.owner.playerHit()
