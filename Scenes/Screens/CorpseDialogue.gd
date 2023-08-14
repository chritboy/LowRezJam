extends CanvasLayer

enum {
	Text1,
	Text2,
	Text3,
	Pause,
	Hide
}

@onready var dialogue = $CorpseDialogue
@onready var egg = preload("res://dialogue_3.tscn")

var state = Hide

func _physics_process(_delta):
	match state:
		Text1:
			dialogue.play("Bubble1")
			await dialogue.animation_finished
			Player.corpse_talk = 2
			state = Pause

		Text2:
			dialogue.play("Bubble2")
			await dialogue.animation_finished
			Player.corpse_talk = 3
			state = Pause
			
		Text3:
			dialogue.play("Bubble3")
			await dialogue.animation_finished
			state = Pause
		Pause:
			if Input.is_action_just_pressed("Attack"):
				dialogue.play("Disappear")
				await dialogue.animation_finished
				get_tree().paused = false
		Hide:
			pass

func _on_area_2d_body_entered(_body):
	if Player.made_egg == true:
		pass
	elif Player.heart == true && Player.lungs == true && Player.stomach == true:
		get_tree().paused = true
		var egg_dialogue = egg.instantiate()
		add_child(egg_dialogue)
		Player.made_egg = true
	elif Player.corpse_talk == 1:
		state = Text1
	elif Player.corpse_talk == 2:
		state = Text2
	elif Player.corpse_talk == 3:
		state = Text3
