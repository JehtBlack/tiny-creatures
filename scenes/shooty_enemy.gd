extends BasicEnemy

@export var preferred_range: float = 150.0

var hold_position: bool = false
var pursuit_delay_timer: Timer

var distance_threshold: float = 25.0

var strafe_timer: Timer

var fire_timer: Timer
@export var fire_rate: float = 5.0

signal spawn_projectile(projectile: PackedScene, spawn_position: Vector2, direction: Vector2, speed: float)

@export var bullet: PackedScene

func _ready() -> void:
	super._ready()

	pursuit_delay_timer = Timer.new()
	add_child(pursuit_delay_timer)
	pursuit_delay_timer.one_shot = true
	pursuit_delay_timer.wait_time = 0.5
	pursuit_delay_timer.timeout.connect(_pursue_player)

	strafe_timer = Timer.new()
	add_child(strafe_timer)
	strafe_timer.one_shot = true
	strafe_timer.wait_time = 0.5
	strafe_timer.timeout.connect(_hold_position)

	fire_timer = Timer.new()
	add_child(fire_timer)
	fire_timer.one_shot = true
	fire_timer.wait_time = 1.0 / fire_rate
	fire_timer.timeout.connect(_shoot)

func _pre_move() -> void:
	if player != null:
		var distance_to_player = global_position.distance_to(player.global_position)
		if distance_to_player > (preferred_range + distance_threshold):
			# player is running away, chase them down!
			hold_position = false
			pursuit_delay_timer.wait_time = randf_range(0.0, 0.5)
			pursuit_delay_timer.start()
			print("%f away! Chasing them down!", distance_to_player)
		elif distance_to_player < preferred_range / 2:
			# player is too close, back off!
			hold_position = false
			_pursue_player()
			print("retreat!")
		else:
			if hold_position:
				# randomly choose whether or not to strafe a bit
				if randf() < 0.1:
					hold_position = false
					_pursue_player()
					strafe_timer.wait_time = randf_range(0.5, 1.0)
					strafe_timer.start()
					print("we do a little juking!")
		

func _move(_delta: float) -> void:
	$NavigationAgent2D.velocity = direction * run_speed if not hold_position else Vector2.ZERO

	if player != null:
		rotation = (player.global_position - global_position).angle() + (PI / 2)

	self.move_and_slide()

func _pursue_player() -> void:
	if player != null:
		var pos = player.global_position

		var to_player_angle = (pos - global_position).angle() - PI
		var lower_bound = to_player_angle - deg_to_rad(30)
		var upper_bound = to_player_angle + deg_to_rad(30)

		var angle = randf_range(lower_bound, upper_bound)
		var offset = Vector2(cos(angle), sin(angle)) * preferred_range
		$NavigationAgent2D.target_position = pos + offset

func _hold_position() -> void:
	hold_position = true

func _on_target_reached() -> void:
	if player != null:
		hold_position = true

func _on_player_detected() -> void:
	fire_timer.start()

func _on_player_lost() -> void:
	hold_position = false
	fire_timer.stop()

func _set_rotation(safe_direction: Vector2) -> void:
	if player == null:
		rotation = safe_direction.angle() + (PI / 2)
	else:
		rotation = (player.global_position - global_position).angle() + (PI / 2)

func _shoot() -> void:
	if player != null:
		var spawn_marker: Node2D = ($ProjectileSpawnMarkers.get_child(randi() % $ProjectileSpawnMarkers.get_child_count()) if $ProjectileSpawnMarkers.get_child_count() > 0 else $ProjectileSpawnMarkers)
		var bullet_direction = (player.global_position - spawn_marker.global_position).normalized()
		spawn_projectile.emit(bullet, spawn_marker.global_position, bullet_direction, 500)
		fire_timer.start()
