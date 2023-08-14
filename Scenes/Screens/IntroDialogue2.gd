extends CanvasLayer

enum {
	Pause,
	Text1,
	Text2,
	Text3,
	Text4,
	Text5,
	Text6
}

@onready var dialogue = $IntroDialogue2
var state = null
var text = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if Player.intro2_over == true:
		text = 6
		state = Pause
	
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
					dialogue.play("IntroDisappear")
					get_tree().paused = false
					Player.intro_over = true
			elif text == 6:
				pass

		Text1:
			if Player.intro1_over == true:
				dialogue.play("IntroBubble1")
				await dialogue.animation_finished
				text = 1
				state = Pause
			else:
				pass
		Text2:
			if Player.intro1_over == true:
				dialogue.play("IntroBubble2")
				await dialogue.animation_finished
				text = 2
				state = Pause
		Text3:
			if Player.intro1_over == true:
				dialogue.play("IntroBubble3")
				await dialogue.animation_finished
				text = 3
				state = Pause
		Text4:
			if Player.intro1_over == true:
				dialogue.play("IntroBubble4")
				await dialogue.animation_finished
				text = 4
				state = Pause
		Text5:
			if Player.intro1_over == true:
				dialogue.play("IntroBubble5")
				await dialogue.animation_finished
				text = 5
				state = Pause
