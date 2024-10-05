extends CharacterBody2D

signal spawn_projectile(projectile: PackedScene, spawn_position: Vector2, direction: Vector2, speed: float)

@export var speed = 400

var look = true

func _ready():
	PlayerData.health_depleted.connect(_on_health_depleted)
	# iterate through guns in PlayerData and instantiate them
	pass

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

func _on_health_depleted():
	print("Player died")
	queue_free()

func _add_gun(gun: PackedScene):
	var left_gun_count = $LeftGuns.get_child_count()
	var right_gun_count = $RightGuns.get_child_count()
	if left_gun_count < right_gun_count:
		_add_gun_to_container(gun, $LeftGuns)
	elif left_gun_count > right_gun_count:
		_add_gun_to_container(gun, $RightGuns)
	else:
		_add_gun_to_container(gun, $LeftGuns if randi() % 2 == 0 else $RightGuns)

func _add_gun_to_container(gun: PackedScene, container: Node2D):
	var new_gun = gun.instantiate()
	container.add_child(new_gun)

func shoot():
	_shoot_guns("ShootLeft", $LeftGuns)
	_shoot_guns("ShootRight", $RightGuns)

func _shoot_guns(action: String, gun_container: Node2D):
	if Input.is_action_pressed(action):
		var just_pressed = Input.is_action_just_pressed(action)
		var mouse_pos = get_global_mouse_position()
		for gun in gun_container.get_children():
			gun.fire(just_pressed, mouse_pos, spawn_projectile)

func hit(damage):
	PlayerData.health -= damage
