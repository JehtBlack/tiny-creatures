extends Marker2D

@export var min_spawn_time = 5.0
@export var max_spawn_time = 15.0

signal spawn_enemy(spawn_position: Vector2)
var spawn_timer: Timer

func _ready() -> void:
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_timer.timeout.connect(attempt_to_spawn_enemy)
	spawn_timer.start()

func attempt_to_spawn_enemy():
	spawn_enemy.emit(global_position)
