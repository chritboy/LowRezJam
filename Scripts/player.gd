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
@onready var anim_effects = $Effects
@onready var hurt_timer = $HurtTimer
@onready var hurtbox = $Hurtbox

@export var speed : int = 50
@export var friction : float = 0.15
@export var acceleration : int = 40

var current_state = MOVE
var is_moving = false
var knockback_power = 500
var invincible = false
var enemy_collisions = []

func _ready():
	anim_tree.active = true
	randomize()
	anim_effects.play("RESET")
	
func _physics_process(_delta):
#	print(current_state)
	match current_state:
		MOVE:
			movement()
			if Input.is_action_just_pressed("Attack"):
				current_state = ATTACK
			elif Input.is_action_just_pressed("Dodge"):
				current_state = DODGE
	
		ATTACK:
			attack()
		
		DODGE:
			dodge()
	
	move_and_slide()
	
	if !invincible:
		for enemy_area in enemy_collisions:
			hurt_by_enemy(enemy_area)
			
func movement():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	
	velocity = input_vector.normalized() * speed
	if velocity == Vector2.ZERO:
		anim_state.travel("Idle")
	else:
		anim_tree.set("parameters/Idle/blend_position", velocity)
		anim_tree.set("parameters/Walk/blend_position", velocity)
		anim_tree.set("parameters/MeleeAtk/blend_position", velocity)
		anim_state.travel("Walk")
	
	
func attack():
	velocity = Vector2.ZERO
	anim_state.travel("MeleeAtk")
	

func attack_finished():
	current_state = MOVE

func dodge():
	if velocity.y > 0:
		if velocity.x > 0:
			velocity.y += 8
			velocity.x += 6
		elif velocity.x < 0:
			velocity.y += 8
			velocity.x -= 6
		else:
			velocity.y += 10
		anim.play("DodgeDown")
		
	elif velocity.y < 0:
		if velocity.x > 0:
			velocity.y -= 6
			velocity.x += 4
		elif velocity.x < 0:
			velocity.y -= 6
			velocity.x -= 4
		else:
			velocity.y -= 8
		anim.play("DodgeUp")
	
	elif velocity.x > 0:
		anim.play("DodgeRight")
		velocity.x += 8
	
	elif velocity.x < 0:
		anim.play("DodgeLeft")
		velocity.x -= 8
	else: 
		current_state = MOVE
	
	move_and_slide()

func hurt_by_enemy(area):
	knockback(area.get_parent().velocity)
	anim_effects.play("Hurt_Blink")
	hurt_timer.start()
	invincible = true

func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":
		enemy_collisions.append(area)
		
func knockback(enemy_velocity):
	var knockback_dir = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_dir
	move_and_slide()

func _on_hurt_timer_timeout():
	anim_effects.play("RESET")
	invincible = false

func _on_hurtbox_area_exited(area):
	enemy_collisions.erase(area)
