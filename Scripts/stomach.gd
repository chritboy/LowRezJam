extends Sprite2D

var player = null

func _ready():
	if Player.stomach == true:
		queue_free()
	player = get_tree().get_first_node_in_group("Player")
	
func _on_area_2d_body_entered(_body):
	Player.stomach = true
	Player.checkpoint = 2
	$AnimationPlayer.play("Pickup")
	SoundPlayer.play_item_grab()
	vanish()

func vanish():
	await $AnimationPlayer.animation_finished
	queue_free()
