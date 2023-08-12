extends CharacterBody2D

enum {
	MOVE,
	MELEEATK,
	RANGEDATK,
	DODGE,
	HURT,
	DEATH
}

signal shoot(bullet_scene, location)
signal health_change

@onready var anim = $AnimationPlayer
@onready var sprite = $Sprite
@onready var anim_tree = $AnimationTree
@onready var anim_state = anim_tree.get("parameters/playback")
@onready var anim_effects = $AnimationFX
@onready var hurt_timer = $HurtTimer
@onready var hurtbox = $Hurtbox/CollisionShape2D2
@onready var bullet = preload("res://Scenes/Characters/bullet.tscn")
@onready var muzzle = $Muzzle
@onready var dodge_particles = $DodgeParticles
@onready var remote_transform = $RemoteTransform2D

@export var speed: int = 50
@export var dodge_speed: int = 175
@export var friction: float = 0.15
@export var acceleration: int = 40

var facing = null
var current_state = MOVE
var is_moving = false
var knockback_power = 100
var invincible = false
var enemy_collisions = []
var muzzle_pos = null
var dodge_vector = Vector2.UP

func _ready():
	anim_tree.active = true
	randomize()
	anim_effects.play("RESET")
	
func _physics_process(delta):
	anim_tree.advance(delta * anim.speed_scale)
	muzzle_position()
	ranged_atk()
	if Player.current_health <= 0:
		anim_effects.play("Death")
		current_state = DEATH
	match current_state:
		MOVE:
			movement()
			if Input.is_action_just_pressed("Attack"):
				SoundPlayer.play_sword()
				current_state = MELEEATK
			elif Input.is_action_just_pressed("Dodge"):
				current_state = DODGE
			elif Input.is_action_just_pressed("Potion") && Player.current_health < 3 && Player.potions > 0:
				potion()
				
		MELEEATK:
			anim_state.travel("MeleeATK")
			melee_attack()
		
		RANGEDATK:
			if Player.ammo > 0 && Input.is_action_just_pressed("Attack"):
				anim_state.travel("RangedATK")
				SoundPlayer.play_shoot()
				shoot.emit(bullet, muzzle.global_position)
				Player.ammo -= 1
			if Input.is_action_just_released("Aim"):
				current_state = MOVE
		
		DODGE:
			dodge_particles.emitting = true
			dodge()
			
		HURT:
			pass
			
		DEATH:
			SoundPlayer.play_player_death()
			SoundPlayer.stop_music()
			hurtbox.disabled = true
			get_tree().paused = true
			await anim_effects.animation_finished
			queue_free()
			Events.emit_signal("player_died")
	
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
	
	move_and_slide()
		
func melee_attack():
	velocity = Vector2.ZERO

func attack_finished():
	self.set_collision_mask_value(4, true)
	hurtbox.disabled = false
	Player.is_dodging = false
	dodge_particles.emitting = false
	current_state = MOVE
	anim_state.travel("Idle")

func dodge():
	self.set_collision_mask_value(4, false)
	Player.is_dodging = true
	hurtbox.disabled = true
	velocity = dodge_vector.normalized() * dodge_speed
	anim_state.travel("Dodge")
	
	move_and_slide()

func hurt_by_enemy(area):
	invincible = true
	SoundPlayer.play_player_hurt()
	Player.current_health -= 1
	health_change.emit(Player.current_health)
	knockback(area.get_parent().velocity)
	hurt_timer.start()
	anim_state.travel("Hurt")
	current_state = HURT
	dodge_particles.emitting = true
	anim_effects.play("Hurt_Blink")

		

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

func potion():
	hurt_timer.start()
	invincible = true
	anim_effects.play("Heal")
	SoundPlayer.play_player_heal()
	Player.potions -= 1
	Player.current_health = 3
	health_change.emit(Player.current_health)

func connect_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
