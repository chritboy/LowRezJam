extends CanvasLayer

@onready var text_container = $TextboxContainer
@onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Dialogue

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_textbox()
	queue_text("First text")
	queue_text("Second text")
	queue_text("Third text")

func _process(_delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty():
				display_text()
		State.READING:
			pass
		State.FINISHED:
			if Input.is_action_just_pressed("Attack"):
				change_state(State.READY)
				text_container.hide()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	label.text = ""
	text_container.hide()
	
func show_textbox():
	text_container.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	change_state(State.READING)
	show_textbox()
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")
