extends CanvasLayer

const DungeonStart = preload("res://Scenes/Screens/DungeonStart.tscn")


func _ready():
	self.hide()

func change_stage(stage_path, x, y):
	self.show()
	$AnimationPlayer.play("TransOut")
	get_tree().paused = true
	await $AnimationPlayer.animation_finished
	
	var stage = stage_path.instantiate()
	get_tree().get_root().get_child(3).free()
	get_tree().get_root().add_child(stage)
	stage.get_node("Player").position = Vector2(x, y)
	
	$AnimationPlayer.play("TransIn")
	await $AnimationPlayer.animation_finished
	self.hide()
	get_tree().paused = false
