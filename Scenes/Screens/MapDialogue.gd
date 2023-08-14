extends CanvasLayer

enum {
	Pause,
	Text1,
	Text2,
	Text3,
	Text4,
	Text5,
	Text6,
	Text7,
	Text8,
	Text9,
	Text10,
}

@onready var dialogue = $IntroDialogue
var state = Text1
var text = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	if Player.intro_over == true:
		text = 11
		state = Pause
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
					state = Text5
			elif text == 5:
				if Input.is_action_just_pressed("Attack"):
					state = Text6
			elif text == 6:
				if Input.is_action_just_pressed("Attack"):
					state = Text7
			elif text == 7:
				if Input.is_action_just_pressed("Attack"):
					state = Text8
			elif text == 8:
				if Input.is_action_just_pressed("Attack"):
					state = Text9
			elif text == 9:
				if Input.is_action_just_pressed("Attack"):
					state = Text10
			elif text == 10:
				if Input.is_action_just_pressed("Attack"):
					dialogue.play("IntroDisappear")
					await dialogue.animation_finished
					get_tree().paused = false
					Player.intro_over = true
					queue_free()
			elif text == 11:
				pass
				

		Text1:
			dialogue.play("IntroBubble1")
			await dialogue.animation_finished
			text = 1
			state = Pause
		Text2:
			dialogue.play("IntroBubble2")
			await dialogue.animation_finished
			text = 2
			state = Pause
		Text3:
			dialogue.play("IntroBubble3")
			await dialogue.animation_finished
			text = 3
			state = Pause
		Text4:
			dialogue.play("IntroBubble4")
			await dialogue.animation_finished
			text = 4
			state = Pause
		Text5:
			dialogue.play("IntroBubble5")
			await dialogue.animation_finished
			text = 5
			state = Pause
		Text6:
			dialogue.play("IntroBubble6")
			await dialogue.animation_finished
			text = 6
			state = Pause
		Text7:
			dialogue.play("IntroBubble7")
			await dialogue.animation_finished
			text = 7
			state = Pause
		Text8:
			dialogue.play("IntroBubble8")
			await dialogue.animation_finished
			text = 8
			state = Pause
		Text9:
			dialogue.play("IntroBubble9")
			await dialogue.animation_finished
			text = 9
			state = Pause
		Text10:
			dialogue.play("IntroBubble10")
			await dialogue.animation_finished
			text = 10
			state = Pause
