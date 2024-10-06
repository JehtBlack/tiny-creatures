extends CharacterBody2D
class_name HealthPickup



func _on_area_2d_body_entered(_body: Node2D) -> void:
	PlayerData.health += 10
	queue_free()
