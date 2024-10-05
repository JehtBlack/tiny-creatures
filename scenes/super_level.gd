extends Node2D
class_name SuperLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_projectile(projectile: PackedScene, spawn_position: Vector2, direction: Vector2, speed: float) -> void:
	var projectile_instance = projectile.instantiate() as Projectile
	projectile_instance.position = spawn_position
	projectile_instance.rotation = direction.angle()
	projectile_instance.speed = speed
	$Projectiles.add_child(projectile_instance)

func _on_player_spawn_projectile(projectile: PackedScene, spawn_position: Vector2, direction: Vector2, speed: float) -> void:
	spawn_projectile(projectile, spawn_position, direction, speed)
