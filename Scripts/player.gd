extends CharacterBody2D

enum {
	MOVE,
	MELEEATK,
	RANGEDATK,
	DODGE,
	HURT
}

signal shoot(bullet_scene, location)
signal health_change

@onready var anim = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var anim_effects = $Effects
@onready var hurt_timer = $HurtTimer
@onready var hurtbox = $Hurtbox/CollisionShape2D2
@onready var bullet = preload("res://Scenes/Characters/bullet.tscn")
@onready var muzzle = $Muzzle

@export var max_health = 3
var current_health = 3
@export var speed : int = 50
@export var dodge_speed : int = 70
@export var friction : float = 0.15
@export var acceleration : int = 40

var facing = null
var current_state = MOVE
var is_moving = false
var knockback_power = 60
var invincible = false
var enemy_collisions = []
var muzzle_pos = null
var ammo = 6
var dodge_vector = Vector2.DOWN

func _ready():
	anim_tree.active = true
	randomize()
	anim_effects.play("RESET")
	
func _physics_process(_delta):
	muzzle_position()
	ranged_atk()
	match current_state:
		MOVE:
			movement()
			if Input.is_action_just_pressed("Attack"):
				current_state = MELEEATK
			elif Input.is_action_just_pressed("Dodge"):
				current_state = DODGE
	
		MELEEATK:
			anim_state.travel("MeleeATK")
			melee_attack()
		
		RANGEDATK:
			if ammo > 0 && Input.is_action_just_pressed("Attack"):
				anim_state.travel("RangedATK")
				shoot.emit(bullet, muzzle.global_position)
				ammo -= 1
			if Input.is_action_just_released("Aim"):
				current_state = MOVE
		
		DODGE:
			anim_state.travel("Dodge")
			dodge()
			
		HURT:
			pass
	move_and_slide()
	
	if !invincible:
		for enemy_area in enemy_collisions:
			hurt_by_enemy(enemy_area)
			
func movement():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	velocity = input_vector.normalized() * speed
	
	if velocity != Vector2.ZERO:
		dodge_vector = input_vector
		anim_tree.set("parameters/Idle/blend_position", velocity)
		anim_tree.set("parameters/Walk/blend_position", velocity)
		anim_tree.set("parameters/MeleeATK/blend_position", velocity)
		anim_tree.set("parameters/RangedATK/blend_position", velocity)
		anim_tree.set("parameters/Dodge/blend_position", velocity)
		anim_tree.set("parameters/Hurt/blend_position", velocity)
		anim_state.travel("Walk")	
	else:
		anim_state.travel("Idle")
		
func melee_attack():
	velocity = Vector2.ZERO

func attack_finished():
	current_state = MOVE
	anim_state.travel("Idle")
	hurtbox.disabled = false

func dodge():
	hurtbox.disabled = true
	velocity = dodge_vector.normalized() * dodge_speed
	move_and_slide()

func hurt_by_enemy(area):
	anim_state.travel("Hurt")
	current_state = HURT
	knockback(area.get_parent().velocity)
	anim_effects.play("Hurt_Blink")
	current_health -= 1
	if current_health <= 0:
		current_health = max_health
	hurt_timer.start()
	invincible = true
	health_change.emit(current_health)

func _on_hurtbox_area_entered(area):
	if area.name == "Hitbox":
		enemy_collisions.append(area)
		
func knockback(enemy_velocity):
	var knockback_dir = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_dir
	move_and_slide()

func _on_hurt_timer_timeout():
	invincible = false

func _on_hurtbox_area_exited(area):
	enemy_collisions.erase(area)

func ranged_atk():
	if Input.is_action_pressed("Aim"):
		velocity = Vector2.ZERO
		anim_state.travel("Idle")
		current_state = RANGEDATK

func muzzle_position():
	if velocity.y < 0:
		muzzle_pos = 2
	elif velocity.y > 0:
		muzzle_pos = -2
	elif velocity.x > 0:
		muzzle_pos = 1
	elif velocity.x < 0:
		muzzle_pos = -1
