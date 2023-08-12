extends Area2D

@export var speed = 200
@onready var player = null
var velocity = Vector2.ZERO

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
func _process(delta):
	if player.muzzle_pos == 1:
		global_position.x += speed * delta
	elif player.muzzle_pos == -1:
		global_position.x += -speed * delta
	elif player.muzzle_pos == 2:
		global_position.y += -speed * delta
	elif player.muzzle_pos == -2:
		global_position.y += speed * delta
	else:
		global_position.y -= speed * delta

func _on_hurtbox_body_entered(_body):
	queue_free()

func _on_timer_timeout():
	queue_free()
