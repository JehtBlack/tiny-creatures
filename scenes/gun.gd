extends Node2D
class_name Gun

@export var bullet: PackedScene
var bullet_exit_speed: int = 500
@export var fire_rate: float = 1.0
var fire_timer: Timer

func _ready() -> void:
	fire_timer = Timer.new()
	add_child(fire_timer)
	fire_timer.wait_time = 1.0 / fire_rate
	fire_timer.one_shot = true

func fire(_fire_just_pressed: bool, _target: Vector2, spawn_signal: Signal) -> void:
	if fire_timer.is_stopped():
		var spawn_marker: Node2D = ($ProjectileSpawnMarkers.get_child(randi() % $ProjectileSpawnMarkers.get_child_count()) if $ProjectileSpawnMarkers.get_child_count() > 0 else $ProjectileSpawnMarkers)
		var direction = Vector2.RIGHT.rotated(spawn_marker.global_rotation).normalized()
		spawn_signal.emit(bullet, spawn_marker.global_position, direction, bullet_exit_speed)
		fire_timer.start()
