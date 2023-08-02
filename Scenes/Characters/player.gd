extends CharacterBody2D
@onready var animated_sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@export var speed : int = 50
@export var friction : float = 0.15
@export var acceleration : int = 40

var is_moving = false

func _physics_process(_delta):
	movement()
	
	
func movement():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	velocity = input_vector * speed
	
	if velocity == Vector2.ZERO:
		anim_tree.get("parameters/playback").travel("Idle")
	else:
		anim_tree.get("parameters/playback").travel("Walk")
		anim_tree.set("parameters/Idle/blend_position", velocity)
		anim_tree.set("parameters/Walk/blend_position", velocity)
	
	move_and_slide()
