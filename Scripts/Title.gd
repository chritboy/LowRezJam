extends CanvasLayer

func _on_start_button_up():
	StageManager.change_stage(StageManager.CreationRoom, 37, 51)

func _on_quit_button_up():
	get_tree().quit()

func _on_controls_button_up():
	get_tree().change_scene_to_file("res://Scenes/UI/Controls.tscn")
