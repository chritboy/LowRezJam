extends CanvasLayer

enum {
	Pause,
	Text1,
	Text2,
	Text3,
	Text4
}

@onready var dialogue = $AnimationPlayer
var state = Text1
var text = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	
func _physics_process(_delta):
	match state:
		Pause:
			if text == 1:
				if Input.is_action_just_pressed("Attack"):
					state = Text2
			elif text == 2:
				if Input.is_action_just_pressed("Attack"):
					state = Text3
			elif text == 3:
				if Input.is_action_just_pressed("Attack"):
					state = Text4
			elif text == 4:
				if Input.is_action_just_pressed("Attack"):
					dialogue.play("Disappear")
					await dialogue.animation_finished
					get_tree().paused = false
					Player.dunking_time = true
					queue_free()

		Text1:
			dialogue.play("Bubble1")
			await dialogue.animation_finished
			text = 1
			state = Pause
		Text2:
			dialogue.play("Bubble2")
			await dialogue.animation_finished
			text = 2
			state = Pause
		Text3:
			dialogue.play("Bubble3")
			await dialogue.animation_finished
			text = 3
			state = Pause
		Text4:
			dialogue.play("Bubble4")
			await dialogue.animation_finished
			text = 4
			state = Pause
