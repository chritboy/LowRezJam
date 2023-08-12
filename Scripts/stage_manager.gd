extends CanvasLayer

const DungeonStart = preload("res://Scenes/Screens/DungeonStart.tscn")
const CrowHub = preload("res://Scenes/Screens/CrowHub.tscn")
signal level_loaded


func _ready():
	self.level_loaded.connect(loaded_level)
	self.hide()

func change_stage(stage_path, x, y):
	self.show()
	$AnimationPlayer.play("TransOut")
	get_tree().paused = true
	await $AnimationPlayer.animation_finished
	
	var stage = stage_path.instantiate()
	get_tree().get_root().get_child(4).free()
	get_tree().get_root().add_child(stage)
	stage.get_node("Player").position = Vector2(x, y)	
	get_tree().paused = false

func loaded_level():
	$AnimationPlayer.play("TransIn")
	await $AnimationPlayer.animation_finished
	self.hide()
