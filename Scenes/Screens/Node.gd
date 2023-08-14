extends Node

@onready var dialogue = $CorpseDialogue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("Attack"):
		dialogue.play("Disappear")
		get_tree().paused = false
