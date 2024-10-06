extends Node2D
class_name SuperLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerData.health_depleted.connect(_on_player_health_depleted)
	
	for enemy in $Enemies.get_children():
		if "enemy_died" in enemy:
			enemy.enemy_died.connect(_spawn_pickup)

func spawn_projectile(projectile: PackedScene, spawn_position: Vector2, direction: Vector2, speed: float) -> void:
	var projectile_instance = projectile.instantiate() as Projectile
	projectile_instance.position = spawn_position
	projectile_instance.rotation = direction.angle()
	projectile_instance.speed = speed
	$Projectiles.add_child(projectile_instance)

func _on_player_spawn_projectile(projectile: PackedScene, spawn_position: Vector2, direction: Vector2, speed: float) -> void:
	spawn_projectile(projectile, spawn_position, direction, speed)

func _on_player_health_depleted() -> void:
	var end_screen = preload("res://scenes/end_screen.tscn").instantiate()
	add_child(end_screen)

@export var glocklin: PackedScene
@export var health_pickup : PackedScene

func _spawn_pickup(spawn_position: Vector2) -> void:
	var toDrop = "health"
	var success = 10

	var item:String
	if randi() % 2:
		item = "glocklin"
	else: item = "health"

	toDrop = item

	var result = randi_range(0, 10)
	print(result)
	

	if result <= success:
		if toDrop == "glocklin":
			var glocklin_instance = glocklin.instantiate() as Glocklin
			$Glocklins.add_child(glocklin_instance)
			glocklin_instance.global_position = spawn_position
			print("Glocklin dropped")
		
		if toDrop == "health":
			var health_pickup_instance = health_pickup.instantiate() as HealthPickup
			add_child(health_pickup_instance)
			health_pickup_instance.global_position = spawn_position
			print("Health dropped")

		print("successful")
		success = 0

	else:
		print("no luck")
		success += 1

	
