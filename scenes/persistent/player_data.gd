extends Node

signal max_health_changed(new_max_health: int)
signal health_changed(new_health: int)
signal health_depleted

@export var spawn_count = 0

@export var max_health: int = 30:
	set(value):
		max_health = max(value, 1)
		max_health_changed.emit(max_health)

var health: int:
	set(value):
		health = min(max(value, 0), max_health)
		health_changed.emit(health)
		if health == 0:
			health_depleted.emit()

var left_guns: Array = []
var right_guns: Array = []

var scene_entry_data_capture: Dictionary

func add_left_gun(gun: PackedScene) -> void:
	_add_gun(left_guns, gun)

func add_right_gun(gun: PackedScene) -> void:
	_add_gun(right_guns, gun)

func remove_left_gun(idx: int) -> void:
	_remove_gun(left_guns, idx)

func remove_right_gun(idx: int) -> void:
	_remove_gun(right_guns, idx)

func _add_gun(guns: Array, gun: PackedScene):
	assert(gun.get_script().is_class("Gun"))
	guns.append(gun)

func _remove_gun(guns: Array, idx: int) -> void:
	assert(idx >= 0 && idx < guns.size())
	guns.remove_at(idx)

func _ready() -> void:
	max_health = 30
	health = max_health
	capture_player_data()
	SceneSwitcher.scene_changed.connect(_on_scene_changed)

func _on_scene_changed() -> void:
	capture_player_data()

func capture_player_data():
	scene_entry_data_capture = Dictionary()
	scene_entry_data_capture["max_health"] = max_health
	scene_entry_data_capture["health"] = health
	scene_entry_data_capture["left_guns"] = left_guns
	scene_entry_data_capture["right_guns"] = right_guns

func restore_capture():
	max_health = scene_entry_data_capture["max_health"]
	health = scene_entry_data_capture["health"]
	left_guns = scene_entry_data_capture["left_guns"]
	right_guns = scene_entry_data_capture["right_guns"]
