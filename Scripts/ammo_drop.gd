extends Sprite2D

var player = null

	
func _on_area_2d_body_entered(_body):
	if Player.potions == 12:
		pass
	else:
		$AnimationPlayer.play("Pickup")
		SoundPlayer.play_item_grab()
		Player.ammo += randi_range(3, 4)
		if Player.ammo > 12:
			Player.ammo = 12
		vanish()

func vanish():
	await $AnimationPlayer.animation_finished
	queue_free()
	
