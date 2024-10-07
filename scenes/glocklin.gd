extends CharacterBody2D
class_name Glocklin

@export var gun: PackedScene

var run_speed = 50
var health = 10

var wait_timer: Timer
var min_wait_time: float = 0.5
var max_wait_time: float = 2.0

func _ready() -> void:
	wait_timer = Timer.new()
	add_child(wait_timer)
	wait_timer.one_shot = true
	wait_timer.timeout.connect(pick_new_target)

	NavigationServer2D.map_changed.connect(_on_nav_map_changed)

func pick_new_target():
	var target_point = NavigationServer2D.map_get_random_point($NavigationAgent2D.get_navigation_map(), 1, false)
	$NavigationAgent2D.target_position = target_point

func rotate_sprite():
	var angle = velocity.angle()
	var frame_index = abs(int(((angle / (2 * PI))) * 8) + 4)
	$Line2D.rotation = angle
	$Sprite2D.frame = frame_index

func _physics_process(_delta):
	var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()
	var direction: Vector2 = (next_path_pos - global_position).normalized()
	$NavigationAgent2D.velocity = direction * run_speed
	move_and_slide()
	rotate_sprite()

func _on_area_pickup_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body._add_gun(gun)
		queue_free()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	# rotation = velocity.angle()


func _on_navigation_agent_2d_target_reached() -> void:
	if wait_timer.is_stopped():
		wait_timer.wait_time = randf_range(min_wait_time, max_wait_time)
		wait_timer.start()

func _on_nav_map_changed(_new_map: RID):
	pick_new_target()
