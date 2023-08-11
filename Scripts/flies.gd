extends CharacterBody2D

enum {
	CHASE,
}

@onready var anim_player = $AnimationPlayer
@onready var soft_coll = $SoftCollision
@onready var hitbox = $Hitbox/CollisionShape2D2

@export var chase_speed = 30

var acceleration = 150
var friction = 50
var current_state = CHASE
var knockback_power = 50
var player = null


func _ready():
	Events.player_died.connect(self.on_player_died)
	player = get_tree().get_first_node_in_group("Player")
	
func _physics_process(delta):
	anim_player.play("V1_Walk")
	if Player.is_dodging == true:
		self.set_collision_mask_value(1, false)
	else:
		self.set_collision_mask_value(1, true)
	
	if player != null:
		var dir = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(dir * chase_speed, acceleration * delta)
		
	if soft_coll.is_colliding():
		velocity += soft_coll.get_push_vector() * delta * 200
		
	$Sprite2D.flip_h = velocity.x < 0
	move_and_slide()

func _on_hurtbox_area_entered(_area):
	queue_free()

func knockback(enemy_velocity):
	var knockback_dir = (enemy_velocity - velocity).normalized() * knockback_power
	velocity = knockback_dir
	move_and_slide()

func on_player_died():
	queue_free()
