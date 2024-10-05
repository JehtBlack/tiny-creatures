extends Area2D
class_name Projectile

var speed: int = 750
var lifespawn_seconds: float = 5.0

func _ready() -> void:
	var lifespan_timer = Timer.new()
	add_child(lifespan_timer)
	lifespan_timer.wait_time = lifespawn_seconds
	lifespan_timer.one_shot = true
	lifespan_timer.timeout.connect(_on_lifespan_timer_timeout)
	lifespan_timer.start()

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_Bullet_body_entered(body):
	hit(body)

func _on_lifespan_timer_timeout() -> void:
	queue_free()

func hit(body: Node2D) -> void:
	print("Generic projectile hit ", body)
