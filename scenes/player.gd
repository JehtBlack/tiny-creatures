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
		_add_gun_to_container(gun, $LeftGuns, true)
	elif left_gun_count > right_gun_count:
		_add_gun_to_container(gun, $RightGuns, false)
	else:
		var choice = randi() % 2
		_add_gun_to_container(gun, $LeftGuns if choice == 0 else $RightGuns, choice == 0)

func _add_gun_to_container(gun: PackedScene, container: Node2D, negative_pos_growth: bool):
	var new_gun = gun.instantiate() as Node2D
	container.add_child(new_gun)
	new_gun.transform = container.transform
	var growth_direction: float = -1.0 if negative_pos_growth else 1.0
	new_gun.position = Vector2.ZERO + (container.get_child_count() * Vector2(0, growth_direction * 20))
	# new_gun.global_position = container.global_position

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
