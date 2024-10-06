extends CharacterBody2D

var run_speed = 50
var health = 10
var player = null

var wait_timer: Timer
var wait_time_min: float = 0.5
var wait_time_max: float = 2.0

var player_tracking_timer: Timer
var player_tracking_time: float = 0.5

func _ready() -> void:
	wait_timer = Timer.new()
	add_child(wait_timer)
	wait_timer.one_shot = true
	wait_timer.timeout.connect(pick_new_target)

	player_tracking_timer = Timer.new()
	add_child(player_tracking_timer)
	player_tracking_timer.one_shot = false
	player_tracking_timer.wait_time = player_tracking_time
	player_tracking_timer.timeout.connect(_track_player)

	NavigationServer2D.map_changed.connect(_on_nav_map_changed)

func pick_new_target() -> void:
	if player == null:
		if wait_timer.is_stopped():
			wait_timer.wait_time = randf_range(wait_time_min, wait_time_max)
			wait_timer.start()
			var target_point = NavigationServer2D.map_get_random_point($NavigationAgent2D.get_navigation_map(), 1, false)
			$NavigationAgent2D.target_position = target_point

func _physics_process(_delta):
	var direction = ($NavigationAgent2D.get_next_path_position() - global_position).normalized()
	velocity = direction * run_speed
	rotation = velocity.angle() + (PI / 2)
	move_and_slide()


func _on_detect_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		player_tracking_timer.start()
		_track_player()
		print("I heard a noise!")


func _on_detect_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_tracking_timer.stop()
		player = null
		$NavigationAgent2D.target_position = global_position
		wait_timer.wait_time = randf_range(wait_time_min, wait_time_max)
		wait_timer.start()
		print("Must be the wind...")

func hit(damage):
	health = health - damage
	if health <= 0:
		Drop.dropItem()
		queue_free()

func _track_player():
	if player != null:
		$NavigationAgent2D.target_position = player.position

func _on_nav_map_changed(_new_map: RID):
	pick_new_target()


func _on_navigation_agent_2d_target_reached() -> void:
	pick_new_target()
