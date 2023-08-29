extends Area2D

signal hit

func _on_area_entered(area):
	if area.name == "enemyHurtBox":
		area.owner.hit(owner.damage)
		emit_signal("hit")
		
