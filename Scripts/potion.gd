extends Sprite2D

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
func _on_area_2d_body_entered(_body):
	if player.potions == 2:
		pass
	else:
		$AnimationPlayer.play("Pickup")
		player.potions += 1
		vanish()

func vanish():
	await $AnimationPlayer.animation_finished
	queue_free()
