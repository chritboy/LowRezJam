extends CharacterBody2D

enum {
	IDLE,
	WANDER,
	CHASE,
	DEATH,
	EXPLODE,
	DEAD
}

@onready var stats = $Stats
@onready var player_detection = $PlayerDetection
@onready var anim_player = $AnimationPlayer
@onready var soft_coll = $SoftCollision
@onready var wander_control = $WanderController
@onready var anim_effects = $Effects
@onready var hurt_timer = $HurtTimer
@onready var hitbox = $Hitbox/CollisionShape2D2

@export var exploder = false
@export var chase_speed = 30
@export var fly_spawn : PackedScene
@export var organ_donor = false
@export var organ : PackedScene

var wander_speed = 5
var acceleration = 150
var friction = 50
var current_state = IDLE
var knockback_power = 70
var player = null
var enemy_container = null


func _ready():
	velocity = Vector2.ZERO
	enemy_container = get_tree().get_first_node_in_group("EnemyHolder")
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(delta):
	if Player.is_dodging == true:
		set_collision_mask_value(1, false)
	else:
		set_collision_mask_value(1, true)
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
				state_picker()
		
		DEATH:
			velocity = Vector2.ZERO
			anim_player.play("Death")
			hitbox.disabled = true
			$SoftCollision/CollisionShape2D.disabled = true
			self.set_collision_mask_value(1, false)
			self.set_collision_layer_value(4, false)
			current_state = DEAD
		
		DEAD:
			await anim_player.animation_finished
			hitbox.disabled = true
			if exploder == true:
				$Hurtbox/CollisionShape2D.disabled = true
			self.set_collision_mask_value(1, false)
			self.set_collision_layer_value(4, false)
			
		EXPLODE:
			velocity = Vector2.ZERO
			anim_player.play("Explode")
			current_state = DEAD
					
	if soft_coll.is_colliding():
		velocity += soft_coll.get_push_vector() * delta * 200
		
	$Sprite2D.flip_h = velocity.x < 0
	move_and_slide()

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	SoundPlayer.play_enemy_hurt()
	$Blood.emitting = true
	if stats.health <= 0 && current_state != DEAD:
		if exploder == true:
			SoundPlayer.play_enemy_explosion()
			current_state = EXPLODE
		elif organ_donor == true:
			current_state = DEATH
			spawn_organ()
		else:
			current_state = DEATH
	knockback(area.get_parent().velocity)
	if current_state != DEAD:
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
	$Blood.emitting = false
	anim_effects.play("RESET")
	
func stop_move():
	velocity = Vector2.ZERO

func _on_explode_radius_body_entered(_body):
	SoundPlayer.play_enemy_explosion()
	current_state = EXPLODE

func spawn_flies():
	var fly_inst = fly_spawn.instantiate()
	fly_inst.global_position = global_position
	enemy_container.add_child(fly_inst)

func spawn_organ():
	var organ_inst = organ.instantiate()
	organ_inst.global_position = global_position
	enemy_container.add_child(organ_inst)
