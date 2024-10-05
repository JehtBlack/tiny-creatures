extends CharacterBody2D


@export var speed = 400

var look = true

func get_input():
	if look == true:
		look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("Left", "Right", "Forwards", "Backwards")
	velocity = input_direction * speed
		
func _physics_process(delta):
	get_input()
	move_and_slide()


func _on_control_mouse_entered():
	look = false
	
func _on_control_mouse_exited():
	look = true
