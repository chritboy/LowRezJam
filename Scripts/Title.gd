extends CanvasLayer




func _on_start_button_up():
	StageManager.change_stage(StageManager.MainHall, 32, 170)

func _on_quit_button_up():
	get_tree().quit()

func _on_controls_button_up():
	get_tree().change_scene_to_file("res://Scenes/UI/Controls.tscn")
