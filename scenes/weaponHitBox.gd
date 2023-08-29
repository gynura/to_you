extends Area2D

func _on_area_entered(area):
	print(area.name)
	if area.name == "EnemyHitBox":
		area.owner.playerHit()
