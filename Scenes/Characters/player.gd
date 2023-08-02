extends CharacterBody2D

enum {
	MOVE,
	ATTACK,
	DODGE
}

@onready var animated_sprite = $Sprite
@onready var anim = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")

@export var speed : int = 50
@export var friction : float = 0.15
@export var acceleration : int = 40

var current_state = MOVE
var is_moving = false


func _ready():
	anim_tree.active = true
	
func _physics_process(_delta):
	match current_state:
		MOVE:
			movement()
			if Input.is_action_just_pressed("Attack"):
				current_state = ATTACK
	
		ATTACK:
			attack()
		
		DODGE:
			pass
	
	
func movement():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	velocity = input_vector * speed
	
	if velocity == Vector2.ZERO:
		anim_state.travel("Idle")
	else:
		anim_tree.set("parameters/Idle/blend_position", velocity)
		anim_tree.set("parameters/Walk/blend_position", velocity)
		anim_tree.set("parameters/MeleeAtk/blend_position", velocity)
		anim_state.travel("Walk")
	
	move_and_slide()

func attack():
	velocity = Vector2.ZERO
	anim_state.travel("MeleeAtk")

func attack_finished():
	current_state = MOVE
