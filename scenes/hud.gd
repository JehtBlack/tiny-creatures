extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerData.max_health_changed.connect(_on_max_health_changed)
	PlayerData.health_changed.connect(_on_health_changed)

	_on_max_health_changed(PlayerData.max_health)
	_on_health_changed(PlayerData.health)

func _on_max_health_changed(new_max_health: int) -> void:
	$MarginContainer/PlayerInfo/HealthBar.max_value = new_max_health

func _on_health_changed(new_health: int) -> void:
	$MarginContainer/PlayerInfo/HealthBar.value = new_health
