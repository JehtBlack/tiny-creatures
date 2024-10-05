extends CharacterBody2D


@export var speed = 400
@export var Bullet : PackedScene

var look = true

func get_input():
	if look == true:
		look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("Left", "Right", "Forward", "Backward")
	velocity = input_direction * speed
	shoot()

		
func _physics_process(delta):
	get_input()
	move_and_slide()


func _on_control_mouse_entered():
	look = false
	
func _on_control_mouse_exited():
	look = true


func shoot():
	if Input.is_action_just_pressed("ShootLeft"):
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.transform = $MuzzleLeft.global_transform
	if Input.is_action_just_pressed("ShootRight"):
		var b = Bullet.instantiate()
		owner.add_child(b)
		b.transform = $MuzzleRight.global_transform
