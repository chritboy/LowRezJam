extends Sprite2D

var player = null
	
func _on_area_2d_body_entered(_body):
	if Player.potions == 2:
		pass
	else:
		$AnimationPlayer.play("Pickup")
		SoundPlayer.play_item_grab()
		Player.potions += 1
		vanish()

func vanish():
	await $AnimationPlayer.animation_finished
	queue_free()
