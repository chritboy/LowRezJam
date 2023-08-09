extends Sprite2D

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
func _on_area_2d_body_entered(body):
	$AnimationPlayer.play("Pickup")
	player.ammo += randi_range(3, 4)
	if player.ammo > 12:
		player.ammo = 12
	vanish()

func vanish():
	await $AnimationPlayer.animation_finished
	queue_free()
