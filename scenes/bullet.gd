extends Projectile


func hit(body: Node2D) -> void:
	if body.is_in_group("damageable"):
		body.hit(5)

	queue_free()
