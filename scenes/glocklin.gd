extends CharacterBody2D

@export var gun: PackedScene

var run_speed = 50
var health = 10
var player = null
var wander_timer: Timer
var wander_time_min: float = 0.2
var wander_time_max: float = 2.0

func _ready() -> void:
	wander_timer = Timer.new()
	add_child(wander_timer)
	wander_timer.one_shot = true
	_adjust_wander_time()

func _adjust_wander_time():
	wander_timer.wait_time = randf_range(wander_time_min, wander_time_max)

func wander():
	if player == null:
		if wander_timer.is_stopped():
			_adjust_wander_time()
			wander_timer.start()
			var direction = Vector2.RIGHT.rotated(randf_range(0.0, PI * 2))
			velocity = direction * (run_speed / 2.0)
			look_at(direction)

func _physics_process(_delta):
	if player != null:
		var direction = position.direction_to(player.position)
		direction = direction.rotated(PI)
		velocity = direction * run_speed
		look_at(direction)
	wander()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body
		print("Glocklin being chased")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = null
		print("You picked the wrong house fool!")


func _on_area_pickup_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body._add_gun(gun)
		queue_free()
