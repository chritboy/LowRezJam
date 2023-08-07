extends CharacterBody2D

enum {
	WANDER,
	WAIT,
	CHASE,
	HURT
}

@export var acceleration = 300
@export var max_speed = 25
@export var friction = 200

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var player_detection_zone = $PlayerDetection

var player = null
var current_state = WAIT


func _physics_process(delta):
	print(current_state)
	match current_state:
		
		WANDER:
			pass
			
		WAIT:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			
		CHASE:
			if player != null:
				var direction = position.direction_to(player.global_position)
				velocity = direction * max_speed
			
		HURT:
			pass
			
	if velocity != Vector2.ZERO:
		anim_player.play("V1_Walk")
	else:
		anim_player.play("V1_Idle")
		
	sprite.flip_h = velocity.x < 0
	move_and_slide()
		

func _on_hurtbox_area_entered(area):
	queue_free()

func _on_player_detection_body_entered(body):
	player = body
	current_state = CHASE

func _on_player_detection_body_exited(body):
	current_state = WAIT
