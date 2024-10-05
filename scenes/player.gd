extends CharacterBody2D

signal spawn_projectile(projectile: PackedScene, spawn_position: Vector2, direction: Vector2, speed: float)

@export var speed = 400
var health = 30

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
	if Input.is_action_pressed("ShootLeft"):
		$GunLeft.fire(Input.is_action_just_pressed("ShootLeft"), get_global_mouse_position(), spawn_projectile)
	if Input.is_action_pressed("ShootRight"):
		$GunRight.fire(Input.is_action_just_pressed("ShootRight"), get_global_mouse_position(), spawn_projectile)


func hit(damage):
	health = health - damage
	if health <= 0:
		pass #fail state of zero health