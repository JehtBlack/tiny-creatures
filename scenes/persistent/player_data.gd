extends Node

signal max_health_changed(new_max_health: int)
signal health_changed(new_health: int)

@export var max_health: int = 30:
    set(value):
        max_health = max(value, 1)
        max_health_changed.emit(max_health)

var health: int:
    set(value):
        health = min(max(value, 0), max_health)
        health_changed.emit(health)

var left_guns: Array = []
var right_guns: Array = []

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
    health = max_health