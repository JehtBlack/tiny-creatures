extends Marker2D

signal spawn_enemy(spawn_position: Vector2)
var spawn_timer: Timer

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = randf_range(9.0, 12.0)
	spawn_timer.timeout.connect(attempt_to_spawn_enemy)
	spawn_timer.start()

func attempt_to_spawn_enemy():
	spawn_enemy.emit(global_position)
