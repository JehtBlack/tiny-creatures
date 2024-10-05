extends CharacterBody2D

signal spawn_projectile(projectile: PackedScene, spawn_position: Vector2, direction: Vector2, speed: float)

@export var speed = 400
@export var bullet: PackedScene

var look = true

func get_input():
	if look == true:
		look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")
	velocity = input_direction * speed
	shoot()

		
func _physics_process(_delta):
	get_input()
	move_and_slide()


func _on_control_mouse_entered():
	look = false
	
func _on_control_mouse_exited():
	look = true


func shoot():
	if Input.is_action_just_pressed("ShootLeft"):
		var direction = Vector2.RIGHT.rotated($MuzzleLeft.global_rotation).normalized()
		spawn_projectile.emit(bullet, $MuzzleLeft.global_position, direction, 500)
	if Input.is_action_just_pressed("ShootRight"):
		var direction = Vector2.RIGHT.rotated($MuzzleRight.global_rotation).normalized()
		spawn_projectile.emit(bullet, $MuzzleRight.global_position, direction, 500)
