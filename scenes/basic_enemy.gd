extends CharacterBody2D

var run_speed = 50
var health = 10
var player = null

func _physics_process(_delta):
	velocity = Vector2.ZERO
	if player != null:
		velocity = position.direction_to(player.position) * run_speed
		look_at(player.position)
	move_and_slide()


func _on_detect_area_body_entered(body: Node2D) -> void:
	player = body
	print("I heard a noise!")


func _on_detect_area_body_exited(body: Node2D) -> void:
	player = null
	print("Must be the wind...")

func hit(damage):
	health = health - damage
	if health <= 0:
		queue_free()
