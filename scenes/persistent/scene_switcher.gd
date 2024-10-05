extends Node

signal scene_changed

func switch_to_scene_packed(packed_scene: PackedScene) -> int:
	var r = get_tree().change_scene_to_packed(packed_scene)
	scene_changed.emit()
	return r

func switch_to_scene_file(path: String) -> int:
	var r = get_tree().change_scene_to_file(path)
	scene_changed.emit()
	return r

func reload_current_scene() -> int:
	var r = get_tree().reload_current_scene()
	scene_changed.emit()
	return r
