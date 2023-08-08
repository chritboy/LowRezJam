extends CharacterBody2D

enum {
	IDLE,
	WANDER,
	CHASE,
	DEATH
}

@onready var stats = $Stats
@onready var player_detection = $PlayerDetection
@onready var anim_player = $AnimationPlayer
@onready var soft_coll = $SoftCollision
@onready var wander_control = $WanderController
@onready var anim_effects = $Effects
@onready var hurt_timer = $HurtTimer
@onready var hitbox = $Hitbox/CollisionShape2D2

var wander_speed = 5
var chase_speed = 30
var acceleration = 150
var friction = 50
var current_state = IDLE
var knockback_power = 50


func _physics_process(delta):
	match current_state:
		
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			anim_player.play("V1_Idle")
			seek_player()
			state_picker()

		WANDER:
			anim_player.play("V1_Walk")
			seek_player()
			state_picker()
			
			var dir = global_position.direction_to(wander_control.target_position)
			velocity = velocity.move_toward(dir * wander_speed, acceleration * delta)
			
			if global_position.distance_to(wander_control.target_position) <= chase_speed * delta:
				state_picker()
			
		CHASE:
			anim_player.play("V1_Walk")
			var player = player_detection.player
			if player != null:
				var dir = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(dir * chase_speed, acceleration * delta)
			else:
				current_state = IDLE
		
		DEATH:
			hitbox.disabled = true
			anim_effects.play("Death")
			await anim_effects.animation_finished
			queue_free()
			
	if soft_coll.is_colliding():
		velocity += soft_coll.get_push_vector() * delta * 200
		
	$Sprite2D.flip_h = velocity.x < 0
	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	if stats.health <= 0:
		current_state = DEATH
	knockback(area.get_parent().velocity)
	anim_effects.play("Hurt")
	
	hurt_timer.start()

func knockback(enemy_velocity):
	var knockback_dir = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_dir
	move_and_slide()
		
func seek_player():
	if player_detection.can_see_player():
		current_state = CHASE
	
func random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func state_picker():
	if wander_control.get_time_left() == 0:
		current_state = random_state([IDLE, WANDER])
		wander_control.start_wander_timer(randi_range(1, 3))

func _on_hurt_timer_timeout():
	anim_effects.play("RESET")
