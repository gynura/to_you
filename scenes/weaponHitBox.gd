extends Area2D

signal enemy_hurt

func _on_area_entered(area):
	if area.name == "EnemyHitBox":
		emit_signal("enemy_hurt")
		area.owner.playerHit()
