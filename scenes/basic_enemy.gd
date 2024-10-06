extends CharacterBody2D
class_name BasicEnemy

signal enemy_died

var run_speed = 50
var health = 10
var player = null

var wait_timer: Timer
var wait_time_min: float = 0.5
var wait_time_max: float = 2.0

var player_tracking_timer: Timer
var player_tracking_time: float = 0.5

var direction: Vector2

func _ready() -> void:
	wait_timer = Timer.new()
	add_child(wait_timer)
	wait_timer.one_shot = true
	wait_timer.timeout.connect(pick_new_target)

	player_tracking_timer = Timer.new()
	add_child(player_tracking_timer)
	player_tracking_timer.one_shot = false
	player_tracking_timer.wait_time = player_tracking_time
	player_tracking_timer.timeout.connect(_pursue_player)

	NavigationServer2D.map_changed.connect(_on_nav_map_changed)

func pick_new_target() -> void:
	if player == null:
		if wait_timer.is_stopped():
			if randf() < 0.5:
				wait_timer.wait_time = randf_range(wait_time_min, wait_time_max)
				wait_timer.start()
			var target_point = NavigationServer2D.map_get_random_point($NavigationAgent2D.get_navigation_map(), 1, false)
			$NavigationAgent2D.target_position = target_point

func _pre_move() -> void:
	pass

func _move(_delta: float) -> void:
	velocity = direction * run_speed
	move_and_slide()
	#assert(false, "Generic enemy move, pick an implemented enemy type")

func _physics_process(delta):
	_pre_move()
	direction = ($NavigationAgent2D.get_next_path_position() - global_position).normalized()
	rotation = direction.angle() + (PI / 2)
	_move(delta)

func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_tracking_timer.start()
		_pursue_player()
		_on_player_detected()
		print("I heard a noise!")


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_tracking_timer.stop()
		player = null
		$NavigationAgent2D.target_position = global_position
		wait_timer.wait_time = randf_range(wait_time_min, wait_time_max)
		wait_timer.start()
		_on_player_lost()
		print("Must be the wind...")

func hit(damage):
	health = health - damage
	if health <= 0:
		enemy_died.emit(global_position)
		queue_free()

func _pursue_player():
	if player != null:
		$NavigationAgent2D.target_position = player.position

func _on_nav_map_changed(_new_map: RID):
	pick_new_target()


func _on_navigation_agent_2d_target_reached() -> void:
	pick_new_target()
	_on_target_reached()

func _on_target_reached() -> void:
	pass

func _on_player_detected() -> void:
	pass

func _on_player_lost() -> void:
	pass
