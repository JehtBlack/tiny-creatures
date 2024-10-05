extends CanvasLayer

@export var level_to_start: PackedScene

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(level_to_start)

func _on_options_pressed() -> void:
	print("HA! You thought...")
	$Menu/Buttons/Options.text = "Ohhh... Bummer"
