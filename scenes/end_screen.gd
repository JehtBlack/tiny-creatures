extends CanvasLayer


func _on_retry_pressed() -> void:
	PlayerData.restore_capture()
	SceneSwitcher.reload_current_scene()


func _on_exit_pressed() -> void:
	get_tree().quit()
